require 'rspec/autorun'
require 'json'
require_relative '../lib/securenative/http_client'
require_relative '../lib/securenative/config'

describe HttpClient do
  let(:config) {Config.new}
  let(:client) {HttpClient.new}

  it "post a request to postman-echo" do
    api_key = "some api key"
    url = "https://postman-echo.com/post"
    res = client.post(url, api_key, "")

    expect(res.status).to eq(200)
    res_body = JSON.parse(res.body)
    expect(res_body["headers"]['content-type']).to eq("application/json")
    expect(res_body["headers"]['user-agent']).to eq("SecureNative-ruby")
    expect(res_body["headers"]['sn-version']).to eq(config.sdk_version)
    expect(res_body["headers"]['authorization']).to eq(api_key)
  end
end