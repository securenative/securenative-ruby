class IpUtils
  VALID_IPV4_PATTERN = ("(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])")
  VALID_IPV6_PATTERN = ("([0-9a-f]{1,4}:){7}([0-9a-f]){1,4}")

  def self.is_ip_address(ip_address)
    if IpUtils.VALID_IPV4_PATTERN.match(ip_address)
      return true
    end
    if IpUtils.VALID_IPV6_PATTERN.match(ip_address)
      return true
    end
    return false
  end

  def self.is_valid_public_ip(ip_address)
    ip = IPAddr.new(ip_address)
    if ip.loopback? || ip.private? || ip.link_local? || ip.untrusted? || ip.tainted?
      return false
    end
    return true
  end

  def self.is_loop_back(ip_address)
    IPAddr.new(ip_address).loopback?
  end
end