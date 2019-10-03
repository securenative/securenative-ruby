require_relative 'config'

class SecureNativeOptions
  def initialize(api_url: Config::API_URL_PROD, interval: 1000, max_events: 1000, timeout: 1500, auto_send: true, debug: false)
    @timeout = timeout
    @max_events = max_events
    @api_url = api_url
    @interval = interval
    @auto_send = auto_send
    @debug = debug
  end

  attr_reader :timeout
  attr_reader :max_events
  attr_reader :api_url
  attr_reader :interval
  attr_reader :auto_send
  attr_reader :debug
end