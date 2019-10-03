require_relative 'event_manager'
require_relative 'config'
require_relative 'sn_exception'
require_relative 'utils'
require 'json'
require 'logger'

class SecureNativeSDK
  def initialize(api_key, options: SecureNativeOptions.new)
    if api_key == nil
      raise SecureNativeSDKException.new
    end

    if options.debug
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
      @logger.info("sn logging was activated")
    end

    @api_key = api_key
    @options = options
    @event_manager = EventManager.new(@api_key, options: @options)
  end

  def api_key
    @api_key
  end

  def version
    Config::SDK_VERSION
  end

  def track(event)
    if @options.debug
      @logger.info("Track event was called")
    end
    validate_event(event)
    @event_manager.send_async(event, Config::TRACK_EVENT)
  end

  def verify(event)
    if @options.debug
      @logger.info("Verify event was called")
    end
    validate_event(event)
    res = @event_manager.send_sync(event, Config::VERIFY_EVENT)
    if res.status_code == 200
      return JSON.parse(res.body)
    end
    nil
  end

  def flow(event) # Note: For future purposes
    validate_event(event)
    @event_manager.send_async(event, Config::FLOW_EVENT)
  end

  def verify_webhook(hmac_header, body)
    if @options.debug
      @logger.info("Verify webhook was called")
    end
    Utils.verify_signature(@api_key, body, hmac_header)
  end

  def flush
    @event_manager.flush
  end

  private

  def validate_event(event)
    unless event.params.nil?
      if event.params.length > Config::MAX_ALLOWED_PARAMS
        event.params = event.params[0, Config::MAX_ALLOWED_PARAMS]
      end
    end
  end
end