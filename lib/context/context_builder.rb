class ContextBuilder
  def initialize
    @context = SecureNativeContext()
  end

  def with_client_token(client_token)
    @context.client_token = client_token
    self
  end

  def with_ip(ip)
    @context.ip = ip
    self
  end

  def with_remote_ip(remote_ip)
    @context.remote_ip = remote_ip
    self
  end

  def with_headers(headers)
    @context.headers = headers
    self
  end

  def with_url(url)
    @context.url = url
    self
  end

  def with_method(method)
    @context.method = method
    self
  end

  def with_body(body)
    @context.body = body
    self
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

    ContextBuilder()
      .with_url(request.url)
      .with_method(request.method)
      .with_headers(headers)
      .with_client_token(client_token)
      .with_ip(RequestUtils.get_client_ip_from_request(request))
      .with_remote_ip(RequestUtils.get_remote_ip_from_request(request))
      .with_body(nil)
  end

  def build
    @context
  end
end