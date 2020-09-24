# frozen_string_literal: true

require 'securenative/models/sdk_event'
require 'securenative/enums/failover_strategy'
require 'securenative/enums/risk_level'
require 'securenative/enums/api_route'
require 'securenative/models/verify_result'
require 'json'

module SecureNative
  class ApiManager
    def initialize(event_manager, securenative_options)
      @event_manager = event_manager
      @options = securenative_options
    end

    def track(event_options)
      SecureNativeLogger.debug('Track event call')
      event = SDKEvent.new(event_options, @options)
      @event_manager.send_async(event, ApiRoute::TRACK)
    end

    def verify(event_options)
      SecureNativeLogger.debug('Verify event call')
      event = SDKEvent.new(event_options, @options)

      begin
        res = @event_manager.send_sync(event, ApiRoute::VERIFY, false)
        ver_result = JSON.parse(res.body)
        return VerifyResult.new(risk_level: ver_result['riskLevel'], score: ver_result['score'], triggers: ver_result['triggers'])
      rescue StandardError => e
        SecureNativeLogger.debug("Failed to call verify; #{e}")
      end
      if @options.fail_over_strategy == FailOverStrategy::FAIL_OPEN
        return VerifyResult.new(risk_level: RiskLevel::LOW, score: 0, triggers: nil)
      end

      VerifyResult.new(risk_level: RiskLevel::HIGH, score: 1, triggers: nil)
    end
  end
end
