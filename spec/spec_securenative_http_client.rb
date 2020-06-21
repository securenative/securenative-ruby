# frozen_string_literal: true

describe SecureNativeHttpClient do
  it 'makes a simple post call' do
    options = ConfigurationManager.config_builder.with_api_key('YOUR_API_KEY').with_api_url('https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track')
      .with(body: { event: 'SOME_EVENT_NAME' }).to_return(status: 200)
    client = SecureNativeHttpClient(options)
    payload = '{"event": "SOME_EVENT_NAME"}'

    res = client.post('track', payload)

    expect(res.ok).to eq(true)
    expect(res.status_code).to eq(200)
    expect(res.text).to eq(payload)
  end
end