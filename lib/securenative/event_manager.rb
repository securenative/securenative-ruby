class EventManager
  def initialize(api_key, options=SecureNativeOptions(), http_client=HTTPClient())
    @api_key = api_key
    @options = options
    @http_client = http_client
  end

  def send_async(event, path)
  end

  def send_sync(event, path)
  end
end