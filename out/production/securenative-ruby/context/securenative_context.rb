# frozen_string_literal: true

class SecureNativeContext
  attr_reader :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body
  attr_writer :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body

  def initialize(client_token = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, http_method = nil, body = nil)
    @client_token = client_token
    @ip = ip
    @remote_ip = remote_ip
    @headers = headers
    @url = url
    @http_method = http_method
    @body = body
  end

  def self.default_context_builder
    SecureNativeContext.new
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

    SecureNativeContext.new(url: request.url, method: request.http_method, header: headers, client_token: client_token,
                            client_ip: RequestUtils.get_client_ip_from_request(request),
                            remote_ip: RequestUtils.get_remote_ip_from_request(request), body: nil)
  end
end
