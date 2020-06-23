require 'httpclient'

class SecureNativeHttpClient
  AUTHORIZATION_HEADER = 'Authorization'.freeze
  VERSION_HEADER = 'SN-Version'.freeze
  USER_AGENT_HEADER = 'User-Agent'.freeze
  USER_AGENT_HEADER_VALUE = 'SecureNative-python'.freeze
  CONTENT_TYPE_HEADER = 'Content-Type'.freeze
  CONTENT_TYPE_HEADER_VALUE = 'application/json'.freeze

  def __init__(securenative_options)
    @options = securenative_options
    @client = HTTPClient.new
  end

  def _headers
    {
        CONTENT_TYPE_HEADER => CONTENT_TYPE_HEADER_VALUE,
        USER_AGENT_HEADER => USER_AGENT_HEADER_VALUE,
        VERSION_HEADER => VersionUtils.version,
        AUTHORIZATION_HEADER => options.api_key
    }
  end

  def post(path, body)
    url = '{}/{}'.format(@options.api_url, path)
    headers = _headers
    @client.post(url, body, headers)
  end
end