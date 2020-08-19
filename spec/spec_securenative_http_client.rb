# frozen_string_literal: true

require 'http/securenative_http_client'
require 'config/configuration_builder'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNativeHttpClient do
  it 'makes a simple post call' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'http://api.securenative-stg.com:443/collector/api/v1/track')
      .with(body: '"{\\"event\\": \\"SOME_EVENT_NAME\\"}"',
            headers: {
              'Accept': '*/*',
              'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization': 'YOUR_API_KEY',
              'Content-Type': 'application/json',
              'Sn-Version': '0.1.19',
              'User-Agent': 'SecureNative-ruby'
            })
      .to_return(status: 200, body: '', headers: {})
    client = SecureNativeHttpClient.new(options)
    payload = '{"event": "SOME_EVENT_NAME"}'

    res = client.post('track', payload)

    expect(res.code).to eq('200')
  end
end
