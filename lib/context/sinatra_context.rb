# frozen_string_literal: true

class SinatraContext
  SECURENATIVE_COOKIE = '_sn'

  def self.get_client_token(request)
    begin
      request.env[SECURENATIVE_COOKIE]
    rescue StandardError
      nil
    end
  end

  def self.get_url(request)
    begin
      request.url
    rescue StandardError
      nil
    end
  end

  def self.get_method(request)
    begin
      request.method
    rescue StandardError
      nil
    end
  end

  def self.get_headers(request)
    begin
      request.headers.to_h
    rescue StandardError
      nil
    end
  end
end
