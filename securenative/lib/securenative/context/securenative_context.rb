class SecureNativeContext
  attr_reader :client_token, :ip, :remote_ip, :headers, :url, :method, :body
  attr_writer :client_token, :ip, :remote_ip, :headers, :url, :method, :body

  def initialize(client_token = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, method = nil, body = nil)
    @client_token = client_token
    @ip = ip
    @remote_ip = remote_ip
    @headers = headers
    @url = url
    @method = method
    @body = body
  end
end