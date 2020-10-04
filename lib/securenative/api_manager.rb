# frozen_string_literal: true

module SecureNative
  class ApiManager
    def initialize(event_manager, securenative_options)
      @event_manager = event_manager
      @options = securenative_options
    end

    def track(event_options)
      SecureNative::Log.debug('Track event call')
      event = SecureNative::SDKEvent.new(event_options, @options)
      @event_manager.send_async(event, SecureNative::Enums::ApiRoute::TRACK)
    end

    def verify(event_options)
      SecureNative::Log.debug('Verify event call')
      event = SecureNative::SDKEvent.new(event_options, @options)

      begin
        res = @event_manager.send_sync(event, SecureNative::Enums::ApiRoute::VERIFY)
        ver_result = JSON.parse(res.body)
        return VerifyResult.new(risk_level: ver_result['riskLevel'], score: ver_result['score'], triggers: ver_result['triggers'])
      rescue StandardError => e
        SecureNative::Log.debug("Failed to call verify; #{e}")
      end
      if @options.fail_over_strategy == SecureNative::FailOverStrategy::FAIL_OPEN
        return SecureNative::VerifyResult.new(risk_level: SecureNative::Enums::RiskLevel::LOW, score: 0, triggers: [])
      end

      VerifyResult.new(risk_level: SecureNative::Enums::RiskLevel::HIGH, score: 1, triggers: [])
    end
  end
end
