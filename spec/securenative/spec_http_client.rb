# frozen_string_literal: true

require 'securenative'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNative::HttpClient do
  it 'makes a simple post call' do
    options = SecureNative::Config::ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track')
      .with(body: '{"event": "SOME_EVENT_NAME"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'YOUR_API_KEY',
              'Content-Type' => 'application/json',
              'Sn-Version' => '0.1.33',
              'User-Agent' => 'SecureNative-ruby'
            }).to_return(status: 200, body: '', headers: {})

    client = SecureNative::HttpClient.new(options)
    payload = '{"event": "SOME_EVENT_NAME"}'

    res = client.post('track', payload)

    expect(res.code).to eq('200')
  end
end
