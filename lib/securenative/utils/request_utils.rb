class RequestUtils
  SECURENATIVE_COOKIE = '_sn'.freeze
  SECURENATIVE_HEADER = 'x-securenative'.freeze

  def self.get_secure_header_from_request(headers)
    return headers[RequestUtils.SECURENATIVE_HEADER] unless headers.nil?

    []
  end

  def self.get_client_ip_from_request(request)
    x_forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
    return x_forwarded_for unless x_forwarded_for.nil?

    request.env['REMOTE_ADDR']
  end

  def self.get_remote_ip_from_request(request)
    request.remote_ip
  end
end