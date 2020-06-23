require_relative 'logger'

class QueueItem
  attr_reader :url, :body, :retry
  attr_writer :url, :body, :retry

  def initialize(url, body, _retry)
    @url = url
    @body = body
    @retry = _retry
  end
end

class EventManager
  def initialize(options = SecureNativeOptions(), http_client = nil)
    if options.api_key.nil?
      raise SecureNativeSDKException('API key cannot be None, please get your API key from SecureNative console.')
    end

    @http_client = if http_client.nil?
                     SecureNativeHttpClient(options)
                   else
                     http_client
                   end

    @queue = []
    @thread = Thread.new(run)
    @thread.start

    @options = options
    @send_enabled = false
    @attempt = 0
    @coefficients = [1, 1, 2, 3, 5, 8, 13]
    @thread = nil
    @interval = options.interval
  end

  def send_async(event, resource_path)
    if @options.disable
      Logger.warning('SDK is disabled. no operation will be performed')
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

  def send_sync(event, resource_path, _retry)
    if @options.disable
      Logger.warning('SDK is disabled. no operation will be performed')
      return
    end

    Logger.debug('Attempting to send event {}'.format(event))
    res = @http_client.post(resource_path, JSON.parse(EventManager.serialize(event)))

    if res.status_code != 200
      Logger.info('SecureNative failed to call endpoint {} with event {}. adding back to queue'.format(resource_path, event))
      item = QueueItem(resource_path, JSON.parse(EventManager.serialize(event)), _retry)
      @queue.append(item)
    end

    res
  end

  def run
    loop do
      next unless !@queue.empty? && @send_enabled

      @queue.each do |item|
        begin
          res = @http_client.post(item.url, item.body)
          if res.status_code == 401
            item.retry = false
          elsif res.status_code != 200
            raise SecureNativeHttpException(res.status_code)
          end
          Logger.debug('Event successfully sent; {}'.format(item.body))
          return res
        rescue StandardError => e
          Logger.error('Failed to send event; {}'.format(e))
          if item.retry
            @attempt = 0 if @coefficients.length == @attempt + 1

            back_off = @coefficients[@attempt] * @options.interval
            Logger.debug('Automatic back-off of {}'.format(back_off))
            @send_enabled = false
            sleep back_off
            @send_enabled = true
          end
        end
      end
      sleep @interval / 1000
    end
  end

  def start_event_persist
    Logger.debug('Starting automatic event persistence')
    if @options.auto_send || @send_enabled
      @send_enabled = true
    else
      Logger.debug('Automatic event persistence is disabled, you should persist events manually')
    end
  end

  def stop_event_persist
    if @send_enabled
      Logger.debug('Attempting to stop automatic event persistence')
      begin
        flush
        @thread&.stop
        Logger.debug('Stopped event persistence')
      rescue StandardError => e
        Logger.error('Could not stop event scheduler; {}'.format(e))
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
            createdAt: obj.user_traits.created_at
        },
        request: {
            cid: obj.request.cid,
            vid: obj.request.vid,
            fp: obj.request.fp,
            ip: obj.request.ip,
            remoteIp: obj.request.remote_ip,
            method: obj.request.method,
            url: obj.request.url,
            headers: obj.request.headers
        },
        timestamp: obj.timestamp,
        properties: obj.properties
    }
  end
end