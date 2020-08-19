# frozen_string_literal: true

class RailsContext
  def self.get_client_token(request)
    begin
      request.cookies[SECURENATIVE_COOKIE]
    rescue StandardError
      nil
    end
  end

  def self.get_url(request)
    begin
      # Rails >= 3.x
      request.fullpath
    rescue StoreError
      begin
        # Rails < 3.x & Sinatra
        request.url if url.nil?
      rescue StoreError
        nil
      end
    end
  end

  def self.get_method(request)
    begin
      request.method
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
