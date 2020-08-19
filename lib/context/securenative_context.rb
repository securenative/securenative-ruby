# frozen_string_literal: true

require 'utils/request_utils'
require 'utils/utils'
require 'context/rails_context'
require 'context/hanami_context'
require 'context/sinatra_context'

class SecureNativeContext
  attr_reader :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body
  attr_writer :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body

  SECURENATIVE_COOKIE = '_sn'

  def initialize(client_token: nil, ip: nil, remote_ip: nil, headers: nil, url: nil, http_method: nil, body: nil)
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
    client_token = RailsContext.get_client_token(request)
    client_token = SinatraContext.get_client_token(request) if client_token.nil?
    client_token = HanamiContext.get_client_token(request) if client_token.nil?

    begin
      headers = RailsContext.get_headers(request)
      headers = SinatraContext.get_headers(request) if headers.nil?
      headers = HanamiContext.get_headers(request) if headers.nil?

      # Standard Ruby request
      headers = request.header.to_hash if headers.nil?
    rescue StandardError
      headers = []
    end

    url = RailsContext.get_url(request)
    url = SinatraContext.get_url(request) if url.nil?
    url = HanamiContext.get_url(request) if url.nil?
    url = '' if url.nil?

    method = RailsContext.get_method(request)
    method = SinatraContext.get_method(request) if method.nil?
    method = HanamiContext.get_method(request) if method.nil?
    method = '' if method.nil?

    begin
      body = request.body.to_s
    rescue StandardError
      body = ''
    end

    client_token = RequestUtils.get_secure_header_from_request(headers) if Utils.null_or_empty?(client_token)

    SecureNativeContext.new(client_token: client_token, ip: RequestUtils.get_client_ip_from_request(request),
                            remote_ip: RequestUtils.get_remote_ip_from_request(request),
                            headers: headers, url: url, http_method: method || '', body: body)
  end
end
