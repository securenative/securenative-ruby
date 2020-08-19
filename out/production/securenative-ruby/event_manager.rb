# frozen_string_literal: true

require 'utils/secure_native_logger'
require 'config/securenative_options'
require 'http/securenative_http_client'
require 'errors/securenative_sdk_error'

class QueueItem
  attr_reader :url, :body, :retry_sending
  attr_writer :url, :body, :retry_sending

  def initialize(url, body, retry_sending)
    @url = url
    @body = body
    @retry = retry_sending
  end
end

class EventManager
  def initialize(options = SecureNativeOptions.new, http_client = nil)
    if options.api_key.nil?
      raise SecureNativeSDKError, 'API key cannot be None, please get your API key from SecureNative console.'
    end

    @http_client = if http_client.nil?
                     SecureNativeHttpClient.new(options)
                   else
                     http_client
                   end

    @queue = []
    @semaphore = Mutex.new
    @interval = options.interval
    @options = options
    @send_enabled = false
    @attempt = 0
    @coefficients = [1, 1, 2, 3, 5, 8, 13]

    @thread = Thread.new {run}
  end

  def send_async(event, resource_path)
    if @options.disable
      SecureNativeLogger.warning('SDK is disabled. no operation will be performed')
      return
    end

    item = QueueItem(resource_path, JSON.parse(EventManager.serialize(event)), false)
    @queue.append(item)
  end

  def flush
    @queue.each do |item|
      @http_client.post(item.url, item.body)
    end
  end

  def send_sync(event, resource_path, retry_sending)
    if @options.disable
      SecureNativeLogger.warning('SDK is disabled. no operation will be performed')
      return
    end

    SecureNativeLogger.debug("Attempting to send event #{event}")
    res = @http_client.post(resource_path, JSON.parse(EventManager.serialize(event)))

    if res.status_code != 200
      SecureNativeLogger.info('SecureNative failed to call endpoint {} with event {}. adding back to queue'.format(resource_path, event))
      item = QueueItem(resource_path, JSON.parse(EventManager.serialize(event)), retry_sending)
      @queue.append(item)
    end

    res
  end

  def run
    loop do
      @semaphore.synchronize do
        next unless !@queue.empty? && @send_enabled

        @queue.each do |item|
          begin
            res = @http_client.post(item.url, item.body)
            if res.status_code == 401
              item.retry_sending = false
            elsif res.status_code != 200
              raise SecureNativeHttpError, res.status_code
            end
            SecureNativeLogger.debug('Event successfully sent; {}'.format(item.body))
            return res
          rescue StandardError => e
            SecureNativeLogger.error('Failed to send event; {}'.format(e))
            if item.retry_sending
              @attempt = 0 if @coefficients.length == @attempt + 1

              back_off = @coefficients[@attempt] * @options.interval
              SecureNativeLogger.debug('Automatic back-off of {}'.format(back_off))
              @send_enabled = false
              sleep back_off
              @send_enabled = true
            end
          end
        end
      end
      sleep @interval / 1000
    end
  end

  def start_event_persist
    SecureNativeLogger.debug('Starting automatic event persistence')
    if @options.auto_send || @send_enabled
      @send_enabled = true
    else
      SecureNativeLogger.debug('Automatic event persistence is disabled, you should persist events manually')
    end
  end

  def stop_event_persist
    if @send_enabled
      SecureNativeLogger.debug('Attempting to stop automatic event persistence')
      begin
        flush
        @thread&.stop
        SecureNativeLogger.debug('Stopped event persistence')
      rescue StandardError => e
        SecureNativeLogger.error('Could not stop event scheduler; {}'.format(e))
      end
    end
  end

  def self.serialize(obj)
    {
      rid: obj.rid,
      eventType: obj.event_type,
      userId: obj.user_id,
      userTraits: {
        name: obj.user_traits.name,
        email: obj.user_traits.email,
        phone: obj.user_traits.phone,
        createdAt: obj.user_traits.created_at
      },
      request: {
        cid: obj.request.cid,
        vid: obj.request.vid,
        fp: obj.request.fp,
        ip: obj.request.ip,
        remoteIp: obj.request.remote_ip,
        http_method: obj.request.http_method,
        url: obj.request.url,
        headers: obj.request.headers
      },
      timestamp: obj.timestamp,
      properties: obj.properties
    }
  end
end
