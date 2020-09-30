# frozen_string_literal: true

class IpUtils
  def self.ip_address?(ip_address)
    return true if ip_address =~ Resolv::IPv4::Regex
    return true if ip_address =~ Resolv::IPv6::Regex

    false
  end

  def self.valid_public_ip?(ip_address)
    ip = IPAddr.new(ip_address)
    return false if ip.loopback? || ip.private? || ip.link_local? || ip.untrusted? || ip.tainted?

    true
  end

  def self.loop_back?(ip_address)
    IPAddr.new(ip_address).loopback?
  end
end
