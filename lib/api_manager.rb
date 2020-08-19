# frozen_string_literal: true

require 'models/sdk_event'
require 'enums/failover_strategy'
require 'json'

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
      res = JSON.parse(@event_manager.send_sync(event, ApiRoute::VERIFY, false))
      return VerifyResult.new(risk_level: res['riskLevel'], score: res['score'], triggers: res['triggers'])
    rescue StandardError => e
      SecureNativeLogger.debug("Failed to call verify; #{e}")
    end
    if @options.fail_over_strategy == FailOverStrategy::FAIL_OPEN
      return VerifyResult.new(risk_level: RiskLevel::LOW, score: 0, triggers: nil)
    end

    VerifyResult.new(risk_level: RiskLevel::HIGH, score: 1, triggers: nil)
  end
end
