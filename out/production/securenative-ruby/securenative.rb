# frozen_string_literal: true

require 'utils/secure_native_logger'
require 'utils/signature_utils'
require 'utils/utils'
require 'errors/securenative_sdk_error'
require 'errors/securenative_sdk_Illegal_state_error'
require 'errors/securenative_config_error'
require 'enums/failover_strategy'
require 'config/configuration_builder'
require 'event_manager'

class SecureNative
  attr_reader :options

  def initialize(options)
    @securenative = nil
    raise SecureNativeSDKError, 'You must pass your SecureNative api key' if Utils.null_or_empty?(options.api_key)

    @options = options
    @event_manager = EventManager.new(@options)

    @event_manager.start_event_persist unless @options.api_url.nil?

    @api_manager = ApiManager.new(@event_manager, @options)
    SecureNativeLogger.init_logger(@options.log_level)
  end

  def self.init_with_options(options)
    if @securenative.nil?
      @securenative = SecureNative.new(options)
      @securenative
    else
      SecureNativeLogger.debug('This SDK was already initialized.')
      raise SecureNativeSDKError, 'This SDK was already initialized.'
    end
  end

  def self.init_with_api_key(api_key)
    raise SecureNativeConfigError, 'You must pass your SecureNative api key' if Utils.null_or_empty?(api_key)

    if @securenative.nil?
      options = ConfigurationBuilder.new(api_key: api_key)
      @securenative = SecureNative.new(options)
      @securenative
    else
      SecureNativeLogger.debug('This SDK was already initialized.')
      raise SecureNativeSDKError, 'This SDK was already initialized.'
    end
  end

  def self.init
    options = ConfigurationManager.load_config
    init_with_options(options)
  end

  def self.instance
    raise SecureNativeSDKIllegalStateError if @securenative.nil?

    @securenative
  end

  def self.config_builder(api_key = nil, api_url = 'https://api.securenative.com/collector/api/v1', interval = 1000,
                          max_events = 1000, timeout = 1500, auto_send = true, disable = false, log_level = 'FATAL',
                          fail_over_strategy = FailOverStrategy::FAIL_OPEN)
    ConfigurationBuilder.new(api_key, api_url, interval, max_events, timeout, auto_send, disable, log_level, fail_over_strategy)
  end

  def self.context_builder(client_token = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, method = nil, body = nil)
    ContextBuilder.new(client_token, ip, remote_ip, headers, url, method, body)
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

  def verify_request_payload(request)
    request_signature = request.header[SignatureUtils.SIGNATURE_HEADER]
    body = request.body

    SignatureUtils.valid_signature?(@options.api_key, body, request_signature)
  end
end
