require_relative '../lib/securenative/event_manager'
require_relative 'securenative/config'
require_relative 'securenative/sn_exception'
require 'json'

class SecureNative
  def initialize(api_key, options = SecureNativeOptions.new)
    if api_key == nil
      raise SecureNativeSDKException.new
    end

    @api_key = api_key
    @options = options
    @event_manager = EventManager.new(@api_key, @options)
  end

  def api_key
    @api_key
  end

  def version
    Config::SDK_VERSION
  end

  def track(event)
    validate_event(event)
    @event_manager.send_async(event, Config::TRACK_EVENT)
  end

  def verify(event) # TODO fix implementation
    validate_event(event)
    res = @event_manager.send_sync(event, Config::VERIFY_EVENT)
    if res.status_code == 200
      return JSON.parse(res.text)
    end
    nil
  end

  def flow(event) # Note: For future purposes
    validate_event(event)
    @event_manager.send_async(event, Config::FLOW_EVENT)
  end

  private

  def validate_event(event)
    # TODO implement me
  end
end