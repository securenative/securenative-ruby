require 'json'
require_relative 'logger'

class ApiManager
  def initialize(event_manager, securenative_options)
    @event_manager = event_manager
    @options = securenative_options
  end

  def track(event_options)
    Logger.debug("Track event call")
    event = SDKEvent.new(event_options, @options)
    @event_manager.send_async(event, ApiRoute::TRACK)
  end

  def verify(event_options)
    Logger.debug("Verify event call")
    event = SDKEvent.new(event_options, @options)

    begin
      res = JSON.parse(@event_manager.send_sync(event, ApiRoute::VERIFY, false))
      return VerifyResult.new(res["riskLevel"], res["score"], res["triggers"])
    rescue StandardError => e
      Logger.debug("Failed to call verify; {}".format(e))
    end
    if @options.fail_over_strategy == FailOverStrategy::FAIL_OPEN
      return VerifyResult.new(RiskLevel::LOW, 0, nil)
    end
    VerifyResult.new(RiskLevel::HIGH, 1, nil)
  end
end