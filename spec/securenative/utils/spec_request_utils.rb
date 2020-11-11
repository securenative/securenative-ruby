# frozen_string_literal: true

require 'securenative'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNative::Utils::RequestUtils do
  it 'extract ip using proxy headers ipv4' do
    options = SecureNative::Options.new
    options.proxy_headers = [
        'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'CF-Connecting-IP' => 'CF-Connecting-IP: 203.0.113.1'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('203.0.113.1')
  end

  it 'extract ip using proxy headers ipv6' do
    options = SecureNative::Options.new
    options.proxy_headers = [
        'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'CF-Connecting-IP' => 'CF-Connecting-IP: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using proxy headers multiple ipv4' do
    options = SecureNative::Options.new
    options.proxy_headers = [
        'CF-Connecting-IP'
    ]

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'CF-Connecting-IP' => 'CF-Connecting-IP: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-forwarded-for header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-forwarded-for' => 'x-forwarded-for: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-forwarded-for header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-forwarded-for' => 'x-forwarded-for: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using x-client-ip header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-client-ip' => 'x-client-ip: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-client-ip header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-client-ip' => 'x-client-ip: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using x-real-ip header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-real-ip' => 'x-real-ip: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-real-ip header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-real-ip' => 'x-real-ip: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using x-forwarded header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-forwarded' => 'x-forwarded: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-forwarded header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-forwarded' => 'x-forwarded: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using x-cluster-client-ip header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-cluster-client-ip' => 'x-cluster-client-ip: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using x-cluster-client-ip header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'x-cluster-client-ip' => 'x-cluster-client-ip: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using forwarded-for header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'forwarded-for' => 'forwarded-for: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using forwarded-for header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'forwarded-for' => 'forwarded-for: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using forwarded header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'forwarded' => 'forwarded: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using forwarded header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'forwarded' => 'forwarded: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using via header ipv6' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'via' => 'via: f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('f71f:5bf9:25ff:1883:a8c4:eeff:7b80:aa2d')
  end

  it 'extract ip using via header multiple ipv4' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers: {'via' => 'via: 141.246.115.116, 203.0.113.1, 12.34.56.3'})

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('141.246.115.116')
  end

  it 'extract ip using priority with x forwarded for' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers:
        {
            'x-forwarded-for' => 'x-forwarded-for: 203.0.113.1',
            'x-real-ip' => 'x-real-ip: 198.51.100.101',
            'x-client-ip' => 'x-client-ip: 198.51.100.102'
        },)

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('203.0.113.1')
  end

  it 'extract ip using priority without x forwarded for' do
    options = SecureNative::Options.new

    stub_request(:get, 'http://www.example.com/')
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: '', headers:
        {
            'x-real-ip' => 'x-real-ip: 198.51.100.101',
            'x-client-ip' => 'x-client-ip: 203.0.113.1, 141.246.115.116, 12.34.56.3'
        },)

    request = Net::HTTP.get_response('www.example.com', '/')
    client_ip = SecureNative::Utils::RequestUtils.get_client_ip_from_request(request, options)

    expect(client_ip).to eq('203.0.113.1')
  end
end
