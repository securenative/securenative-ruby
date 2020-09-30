# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe IpUtils do
  it 'checks if ip address valid ipv4' do
    valid_ipv4 = '172.16.254.1'
    expect(IpUtils.ip_address?(valid_ipv4)).to be_truthy
  end

  it 'checks if ip address valid ipv6' do
    valid_ipv6 = '2001:db8:1234:0000:0000:0000:0000:0000'
    expect(IpUtils.ip_address?(valid_ipv6)).to be_truthy
  end

  it 'checks if ip address invalid ipv4' do
    invalid_ipv4 = '172.16.2541'
    expect(IpUtils.ip_address?(invalid_ipv4)).to be_falsey
  end

  it 'checks if ip address invalid ipv6' do
    invalid_ipv6 = '2001:db8:1234:0000'
    expect(IpUtils.ip_address?(invalid_ipv6)).to be_falsey
  end

  it 'checks if valid public ip' do
    ip = '64.71.222.37'
    expect(IpUtils.valid_public_ip?(ip)).to be_truthy
  end

  it 'checks if not valid public ip' do
    ip = '10.0.0.0'
    expect(IpUtils.valid_public_ip?(ip)).to be_falsey
  end

  it 'checks if valid loopback ip' do
    ip = '127.0.0.1'
    expect(IpUtils.loop_back?(ip)).to be_truthy
  end
end
