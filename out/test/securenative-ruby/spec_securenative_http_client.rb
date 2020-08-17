# frozen_string_literal: true

require 'http/securenative_http_client'
require 'config/configuration_builder'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNativeHttpClient do
  it 'makes a simple post call' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track')
      .with(body: { event: 'SOME_EVENT_NAME' }).to_return(status: 200)
    client = SecureNativeHttpClient.new(options)
    payload = '{"event": "SOME_EVENT_NAME"}'

    res = client.post('track', payload)

    expect(res.ok).to eq(true)
    expect(res.status_code).to eq(200)
    expect(res.text).to eq(payload)
  end
end
