# frozen_string_literal: true

module SecureNative
  class Context
    attr_reader :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body
    attr_writer :client_token, :ip, :remote_ip, :headers, :url, :http_method, :body

    SECURENATIVE_COOKIE = '_sn'

    def initialize(client_token: '', ip: '', remote_ip: '', headers: nil, url: '', http_method: '', body: '')
      @client_token = client_token
      @ip = ip
      @remote_ip = remote_ip
      @headers = headers
      @url = url
      @http_method = http_method
      @body = body
    end

    def self.default_context_builder
      SecureNative::Context.new
    end

    def self.from_http_request(request, options)
      client_token = SecureNative::Frameworks::Rails.get_client_token(request)
      client_token = SecureNative::Frameworks::Sinatra.get_client_token(request) if client_token.nil?
      client_token = SecureNative::Frameworks::Hanami.get_client_token(request) if client_token.nil?

      begin
        headers = SecureNative::Frameworks::Rails.get_headers(request)
        headers = SecureNative::Frameworks::Sinatra.get_headers(request) if headers.nil?
        headers = SecureNative::Frameworks::Hanami.get_headers(request) if headers.nil?

        # Standard Ruby request
        headers = request.header.to_hash if headers.nil?
      rescue StandardError
        headers = {}
      end

      url = SecureNative::Frameworks::Rails.get_url(request)
      url = SecureNative::Frameworks::Sinatra.get_url(request) if url.nil?
      url = SecureNative::Frameworks::Hanami.get_url(request) if url.nil?
      url = '' if url.nil?

      method = SecureNative::Frameworks::Rails.get_method(request)
      method = SecureNative::Frameworks::Sinatra.get_method(request) if method.nil?
      method = SecureNative::Frameworks::Hanami.get_method(request) if method.nil?
      method = '' if method.nil?

      begin
        body = request.body.to_s
      rescue StandardError
        body = ''
      end

      if SecureNative::Utils::Utils.null_or_empty?(client_token)
        client_token = SecureNative::Utils::RequestUtils.get_secure_header_from_request(request.headers)
      end

      SecureNative::Context.new(client_token: client_token, ip: SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options),
                                remote_ip: SecureNative::Utils::RequestUtils.get_remote_ip_from_request(request),
                                headers: headers, url: url, http_method: method || '', body: body)
    end
  end
end
