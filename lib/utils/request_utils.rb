# frozen_string_literal: true

class RequestUtils
  SECURENATIVE_COOKIE = '_sn'
  SECURENATIVE_HEADER = 'x-securenative'

  def self.get_secure_header_from_request(headers)
    begin
      return headers[SECURENATIVE_HEADER] unless headers.nil?
    rescue StandardError
      []
    end
    []
  end

  def self.get_client_ip_from_request(request)
    begin
      return request.ip unless request.ip.nil?
    rescue NoMethodError
    end

    begin
      x_forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
      return x_forwarded_for unless x_forwarded_for.nil?
    rescue NoMethodError
      begin
        x_forwarded_for = request['HTTP_X_FORWARDED_FOR']
        return x_forwarded_for unless x_forwarded_for.nil?
      rescue NoMethodError
      end
    end

    begin
      x_forwarded_for = request.env['REMOTE_ADDR']
      return x_forwarded_for unless x_forwarded_for.nil?
    rescue NoMethodError
      begin
        x_forwarded_for = request['REMOTE_ADDR']
        return x_forwarded_for unless x_forwarded_for.nil?
      rescue NoMethodError
      end
    end

    ''
  end

  def self.get_remote_ip_from_request(request)
    begin
      request.remote_ip
    rescue NoMethodError
      ''
    end
  end
end
