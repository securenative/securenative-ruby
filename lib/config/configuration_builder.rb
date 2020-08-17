# frozen_string_literal: true

require 'enums/failover_strategy'

class ConfigurationBuilder
  attr_reader :api_key, :api_url, :interval, :max_events, :timeout, :auto_send, :disable, :log_level, :fail_over_strategy
  attr_writer :api_key, :api_url, :interval, :max_events, :timeout, :auto_send, :disable, :log_level, :fail_over_strategy

  def initialize(api_key: nil, api_url: 'https://api.securenative.com/collector/api/v1', interval: 1000,
                 max_events: 1000, timeout: 1500, auto_send: true, disable: false, log_level: 'FATAL',
                 fail_over_strategy: FailOverStrategy::FAIL_OPEN)
    @api_key = api_key
    @api_url = api_url
    @interval = interval
    @max_events = max_events
    @timeout = timeout
    @auto_send = auto_send
    @disable = disable
    @log_level = log_level
    @fail_over_strategy = fail_over_strategy
  end

  def self.default_config_builder
    ConfigurationBuilder.new
  end

  def self.default_securenative_options
    SecureNativeOptions.new
  end
end
