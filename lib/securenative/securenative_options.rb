class SecureNativeOptions
  def initialize(api_url = Config.securenative_prod, interval = 1000, max_events = 1000, timeout = 1500, auto_send = true)
    @timeout = timeout
    @max_events = max_events
    @api_url = api_url
    @interval = interval
    @auto_send = auto_send
  end
end