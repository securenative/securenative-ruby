module HTTPClient
  @client = HTTPClient.new

  def headers(api_key)
    {
        "Content-Type" => 'application/json',
        "User-Agent" => 'SecureNative-python',
        "Sn-Version" => Config.sdk_version,
        "Authorization" => api_key
    }
  end

  def post(url, api_key, body)
    @client.post(url, body, self.headers(api_key))
  end
end