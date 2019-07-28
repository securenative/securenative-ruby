require 'httpclient'

class HttpClient
  def initialize
    @client = HTTPClient.new
  end

  def headers(api_key)
    {
        "Content-Type" => 'application/json',
        "User-Agent" => 'SecureNative-ruby',
        "Sn-Version" => Config::SDK_VERSION,
        "Authorization" => api_key
    }
  end

  def post(url, api_key, body)
    @client.post(url, body, self.headers(api_key))
  end
end