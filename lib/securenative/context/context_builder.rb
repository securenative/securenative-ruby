class ContextBuilder
  attr_reader :context

  def initialize(client_token = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, method = nil, body = nil)
    @context = SecureNativeContext(client_token, ip, remote_ip, headers, url, method, body)
  end

  def client_token(client_token)
    @context.client_token = client_token
  end

  def ip(ip)
    @context.ip = ip
  end

  def remote_ip(remote_ip)
    @context.remote_ip = remote_ip
  end

  def headers(headers)
    @context.headers = headers
  end

  def url(url)
    @context.url = url
  end

  def method(method)
    @context.method = method
  end

  def body(body)
    @context.body = body
  end

  def self.default_context_builder
    ContextBuilder()
  end

  def self.from_http_request(request)
    begin
      client_token = request.cookies[RequestUtils.SECURENATIVE_COOKIE]
    rescue StandardError
      client_token = nil
    end

    begin
      headers = request.headers
    rescue StandardError
      headers = nil
    end

    client_token = RequestUtils.get_secure_header_from_request(headers) if Utils.null_or_empty?(client_token)

    ContextBuilder(url = request.url, method = request.method, header = headers, client_token = client_token,
                   client_ip = RequestUtils.get_client_ip_from_request(request),
                   remote_ip = RequestUtils.get_remote_ip_from_request(request), nil)
  end
end