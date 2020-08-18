# frozen_string_literal: true

require 'utils/request_utils'
require 'utils/utils'

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
    begin
      client_token = request.cookies[RequestUtils.SECURENATIVE_COOKIE]
    rescue StandardError
      client_token = nil
    end

    client_token = request[SECURENATIVE_COOKIE] if client_token.nil?
    client_token = request['-sn'] if client_token.nil? # bypass webmock parsing header bug

    begin
      parsed = JSON.parse(request.body)
    rescue StandardError
      parsed = {}
    end

    begin
      headers = request.header.to_hash
    rescue StandardError
      headers = nil
    end

    client_token = RequestUtils.get_secure_header_from_request(headers) if Utils.null_or_empty?(client_token)

    SecureNativeContext.new(client_token: client_token, ip: parsed['ip'] || RequestUtils.get_client_ip_from_request(request),
                            remote_ip: parsed['remote_ip'] || RequestUtils.get_remote_ip_from_request(parsed),
                            headers: headers, url: parsed['uri'] || '', http_method: parsed['http_method'] || '', body: nil)
  end
end
