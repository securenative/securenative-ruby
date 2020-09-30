# frozen_string_literal: true

module SecureNative
  class HttpClient
    AUTHORIZATION_HEADER = 'Authorization'
    VERSION_HEADER = 'SN-Version'
    USER_AGENT_HEADER = 'User-Agent'
    USER_AGENT_HEADER_VALUE = 'SecureNative-ruby'
    CONTENT_TYPE_HEADER = 'Content-Type'
    CONTENT_TYPE_HEADER_VALUE = 'application/json'

    def initialize(securenative_options)
      @options = securenative_options
    end

    def _headers
      {
          CONTENT_TYPE_HEADER => CONTENT_TYPE_HEADER_VALUE,
          USER_AGENT_HEADER => USER_AGENT_HEADER_VALUE,
          VERSION_HEADER => VersionUtils.version,
          AUTHORIZATION_HEADER => @options.api_key
      }
    end

    def post(path, body)
      uri = URI.parse("#{@options.api_url}/#{path}")
      headers = _headers

      client = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl = true
      client.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = body

      res = nil
      begin
        res = client.request(request)
      rescue StandardError => e
        SecureNative::Log.error("Failed to send request; #{e}")
        return res
      end
      res
    end
  end
end
