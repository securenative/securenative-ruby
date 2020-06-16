class ConfigurationBuilder
  def initialize
    @api_key = nil
    @api_url = "https://api.securenative.com/collector/api/v1"
    @interval = 1000
    @max_events = 1000
    @timeout = 1500
    @auto_send = true
    @disable = false
    @log_level = "FATAL"
    @fail_over_strategy = FailOverStrategy::FAIL_OPEN
  end

  def self.default_config_builder
    return ConfigurationBuilder()
  end

  def with_api_key(api_key)
    @api_key = api_key
    self
  end

  def with_api_url(api_url)
    @api_url = api_url
    self
  end

  def with_interval(interval)
    @interval = interval
    self
  end

  def with_max_events(max_events)
    @max_events = max_events
    self
  end

  def with_timeout(timeout)
    @timeout = timeout
    self
  end

  def with_auto_send(auto_send)
    @auto_send = auto_send
    self
  end

  def with_disable(disable)
    @disable = disable
    self
  end

  def with_log_level(log_level)
    @log_level = log_level
    self
  end

  def with_fail_over_strategy(fail_over_strategy)
    if fail_over_strategy != FailOverStrategy::FAIL_OPEN && fail_over_strategy != FailOverStrategy::FAIL_CLOSED
      @fail_over_strategy = FailOverStrategy::FAIL_OPEN
      self
    else
      @fail_over_strategy = fail_over_strategy
      self
    end
  end

  def self.default_securenative_options
    return SecureNativeOptions()
  end
end