# frozen_string_literal: true

class HanamiContext
  def self.get_client_token(request)
    begin
      request.env[SECURENATIVE_COOKIE]
    rescue StandardError
      nil
    end
  end

  def self.get_url(request)
    begin
      request.env['REQUEST_PATH']
    rescue StoreError
      nil
    end
  end

  def self.get_method(request)
    begin
      request.request_method
    rescue StoreError
      nil
    end
  end

  def self.get_headers(request)
    begin
      request.headers.to_hash
    rescue StoreError
      nil
    end
  end
end
