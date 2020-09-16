# frozen_string_literal: true

require 'config/securenative_options'
require 'utils/request_utils'
require 'webmock/rspec'
require 'rspec'

RSpec.describe RequestUtils do
  it 'extract a request with proxy headers' do
    options = SecureNativeOptions.new
    options.proxy_headers = [
      'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/').with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: '', headers: { 'CF-Connecting-IP' => 'CF-Connecting-IP: 203.0.113.1' })

    request = Net::HTTP.get_response('www.example.com', '/')
    RequestUtils.get_client_ip_from_request(request, options)
  end
end
