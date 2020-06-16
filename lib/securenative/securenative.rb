require_relative 'logger'

class SecureNative
  def initialize(options)
    @securenative = nil
    if Utils.is_null_or_empty(options.api_key)
      raise SecureNativeSDKException("You must pass your SecureNative api key")
    end

    @options = options
    @event_manager = EventManager(@options)

    unless @options.api_url.nil?
      @event_manager.start_event_persist
    end

    @api_manager = ApiManager.new(@event_manager, @options)
    Logger.init_logger(@options.log_level)
  end

  def self.init_with_options(options)
    if @securenative.nil?
      @securenative = SecureNative.new(options)
      return @securenative
    else
      Logger.debug('This SDK was already initialized.')
      raise SecureNativeSDKException(u 'This SDK was already initialized.')
    end
  end

  def self.init_with_api_key(api_key)
    if Utils.is_null_or_empty(api_key)
      raise SecureNativeConfigException("You must pass your SecureNative api key")
    end

    if @securenative.nil?
      builder = ConfigurationBuilder().default_config_builder
      options = builder.with_api_key(api_key)
      @securenative = SecureNative.new(options)
      return @securenative
    else
      Logger.debug('This SDK was already initialized.')
      raise SecureNativeSDKException(u 'This SDK was already initialized.')
    end
  end

  def self.init
    options = ConfigurationManager.load_config
    init_with_options(options)
  end

  def self.get_instance
    if @securenative.nil?
      raise SecureNativeSDKIllegalStateException()
    end
    return @securenative
  end

  def get_options
    @options
  end


  def self.config_builder
    return ConfigurationBuilder.default_config_builder
  end

  def self.context_builder
    return ContextBuilder.default_context_builder
  end

  def track(event_options)
    @api_manager.track(event_options)
  end

  def verify(event_options)
    @api_manager.verify(event_options)
  end

  def self._flush
    @securenative = nil
  end
end