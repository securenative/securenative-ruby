class IpUtils
  VALID_IPV4_PATTERN = '(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])'.freeze
  VALID_IPV6_PATTERN = '([0-9a-f]{1,4}:){7}([0-9a-f]){1,4}'.freeze

  def self.ip_address?(ip_address)
    return true if IpUtils.VALID_IPV4_PATTERN.match(ip_address)
    return true if IpUtils.VALID_IPV6_PATTERN.match(ip_address)

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