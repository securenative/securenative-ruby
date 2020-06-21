class RequestUtils
  SECURENATIVE_COOKIE = "_sn"
  SECURENATIVE_HEADER = "x-securenative"

  def self.get_secure_header_from_request(headers)
    unless headers.nil?
      return headers[RequestUtils.SECURENATIVE_HEADER]
    end
    return []
  end

  def self.get_client_ip_from_request(request)
    x_forwarded_for = request.env["HTTP_X_FORWARDED_FOR"]
    unless x_forwarded_for.nil?
      return x_forwarded_for
    end
    return request.env["REMOTE_ADDR"]
  end

  def self.get_remote_ip_from_request(request)
    return request.remote_ip
  end
end