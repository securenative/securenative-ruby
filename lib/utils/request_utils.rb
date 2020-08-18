# frozen_string_literal: true

class RequestUtils
  SECURENATIVE_COOKIE = '_sn'
  SECURENATIVE_HEADER = 'x-securenative'

  def self.get_secure_header_from_request(headers)
    return headers[RequestUtils.SECURENATIVE_HEADER] unless headers.nil?

    []
  end

  def self.get_client_ip_from_request(request)
    begin
      x_forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
      return x_forwarded_for unless x_forwarded_for.nil?
    rescue NoMethodError
      return ''
    end

    request.env['REMOTE_ADDR']
  end

  def self.get_remote_ip_from_request(request)
    begin
      request.remote_ip
    rescue NoMethodError
      return ''
    end
  end
end
