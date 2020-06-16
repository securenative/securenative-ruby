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
    return ContextBuilder()
  end

  def self.from_http_request(request)
    #  TODO implement me
  end

  def build
    @context
  end
end