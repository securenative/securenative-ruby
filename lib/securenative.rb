class SecureNative
  def initialize(api_key, options=SecureNativeOptions())
    if api_key == nil
      raise ArgumentError.new('API key cannot be None, please get your API key from SecureNative console.')
    end

    @api_key = api_key
    @options = options
    @event_manager = EventManager(@api_key, @options)
  end

  def track(event)
  end

  def verify(event)
  end

  def flow(event)
  end

  private
  def validate_event(event)
  end
end