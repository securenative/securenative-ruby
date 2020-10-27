# frozen_string_literal: true

require 'securenative'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNative::Utils::RequestUtils do
  it 'extract a request with proxy headers ipv4' do
    options = SecureNative::Options.new
    options.proxy_headers = [
      'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Ruby'
            }).to_return(status: 200, body: '', headers: { 'CF-Connecting-IP' => 'CF-Connecting-IP: 203.0.113.1' })

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('203.0.113.1')
  end

  it 'extract a request with proxy headers ipv6' do
    options = SecureNative::Options.new
    options.proxy_headers = [
        'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: { 'CF-Connecting-IP' => 'CF-Connecting-IP: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d' })

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract a request with proxy headers multiple ipv4' do
    options = SecureNative::Options.new
    options.proxy_headers = [
        'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: { 'CF-Connecting-IP' => 'CF-Connecting-IP: 141.246.115.116, 203.0.113.1, 12.34.56.3' })

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end
end
