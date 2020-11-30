# frozen_string_literal: true

module SecureNative
  module Config
    class ConfigurationBuilder
      attr_reader :api_key, :api_url, :interval, :max_events, :timeout, :auto_send, :disable, :log_level, :fail_over_strategy, :proxy_headers, :pii_headers, :pii_regex_pattern
      attr_writer :api_key, :api_url, :interval, :max_events, :timeout, :auto_send, :disable, :log_level, :fail_over_strategy, :proxy_headers, :pii_headers, :pii_regex_pattern

      def initialize(api_key: nil, api_url: 'https://api.securenative.com/collector/api/v1', interval: 1000,
                     max_events: 1000, timeout: 1500, auto_send: true, disable: false, log_level: 'FATAL',
                     fail_over_strategy: SecureNative::FailOverStrategy::FAIL_OPEN, proxy_headers: nil,
                     pii_headers: nil, pii_regex_pattern: nil)
        @api_key = api_key
        @api_url = api_url
        @interval = interval
        @max_events = max_events
        @timeout = timeout
        @auto_send = auto_send
        @disable = disable
        @log_level = log_level
        @fail_over_strategy = fail_over_strategy
        @proxy_headers = proxy_headers
        @pii_headers = pii_headers
        @pii_regex_pattern = @pii_regex_pattern
      end

      def self.default_securenative_options
        Options.new
      end
    end
  end
end
