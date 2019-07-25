require 'json'

class SecureNative
  def initialize(api_key, options = SecureNativeOptions())
    if api_key == nil
      raise ArgumentError.new('API key cannot be nil, please get your API key from SecureNative console.')
    end

    @api_key = api_key
    @options = options
    @event_manager = EventManager(@api_key, @options)
  end

  def api_key
    @api_key
  end

  def track(event)
    self.validate_event(event)
    @event_manager.send_async(event, Config.track_event)
  end

  def verify(event) # TODO fix implementation
    self.validate_event(event)
    res = @event_manager.send_sync(event, Config.verify_event)
    if res.status_code == 200
      return JSON.parse(res.text)
    end
    nil
  end

  private

  def validate_event(event)
  end
end