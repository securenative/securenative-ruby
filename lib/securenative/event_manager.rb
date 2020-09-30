# frozen_string_literal: true

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
  attr_reader :activated

  def initialize(options = Options.new, http_client = nil)
    if options.api_key.nil?
      raise SecureNativeSDKError, 'API key cannot be None, please get your API key from SecureNative console.'
    end

    @http_client = if http_client.nil?
                     SecureNative::HttpClient.new(options)
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

    @activated = false
    @thread = nil
  end

  def send_async(event, resource_path)
    if @options.disable
      SecureNative::Log.warning('SDK is disabled. no operation will be performed')
      return
    end

    unless @activated
      @thread = Thread.new { run }
      @activated = true
    end

    item = QueueItem.new(resource_path, EventManager.serialize(event).to_json, false)
    @queue.append(item)
  end

  def flush
    @queue.each do |item|
      @http_client.post(item.url, item.body)
    end
  end

  def send_sync(event, resource_path, retry_sending)
    if @options.disable
      SecureNative::Log.warning('SDK is disabled. no operation will be performed')
      return
    end

    SecureNative::Log.debug("Attempting to send event #{event}")
    res = @http_client.post(resource_path, EventManager.serialize(event).to_json)

    if res.nil? || res.code != '200'
      SecureNative::Log.info("SecureNative failed to call endpoint #{resource_path} with event #{event}. adding back to queue")
      item = QueueItem.new(resource_path, EventManager.serialize(event).to_json, retry_sending)
      @queue.append(item)
    end

    res
  end

  def run
    loop do
      @semaphore.synchronize do
        if (item = !@queue.empty? && @send_enabled)
          begin
            item = @queue.shift
            res = @http_client.post(item.url, item.body)
            if res.code == '401'
              item.retry_sending = false
            elsif res.code != '200'
              @queue.append(item)
              raise SecureNativeHttpError, res.status_code
            end
            SecureNative::Log.debug("Event successfully sent; #{item.body}")
          rescue Exception => e
            SecureNative::Log.error("Failed to send event; #{e}")
            if item.retry_sending
              @attempt = 0 if @coefficients.length == @attempt + 1

              back_off = @coefficients[@attempt] * @options.interval
              SecureNative::Log.debug("Automatic back-off of #{back_off}")
              @send_enabled = false
              sleep back_off
              @send_enabled = true
            end
          end
        end
      end
      sleep @interval / 1000 if @queue.empty?
    end
  end

  def start_event_persist
    SecureNative::Log.debug('Starting automatic event persistence')
    if @options.auto_send || @send_enabled
      @send_enabled = true
    else
      SecureNative::Log.debug('Automatic event persistence is disabled, you should persist events manually')
    end
  end

  def stop_event_persist
    if @send_enabled
      SecureNative::Log.debug('Attempting to stop automatic event persistence')
      begin
        flush
        @thread&.stop?
        SecureNative::Log.debug('Stopped event persistence')
      rescue StandardError => e
        SecureNative::Log.error("Could not stop event scheduler; #{e}")
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
            method: obj.request.http_method || '',
            url: obj.request.url,
            headers: obj.request.headers
        },
        timestamp: obj.timestamp,
        properties: obj.properties
    }
  end
end
