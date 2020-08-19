# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class SecureNativeHttpClient
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
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = body.to_json

    client.request(request)
  end
end
