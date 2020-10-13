# frozen_string_literal: true

module SecureNative
  module Frameworks
    class Rails
      SECURENATIVE_COOKIE = '_sn'

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
        rescue StandardError
          begin
            # Rails < 3.x & Sinatra
            request.url if url.nil?
          rescue StandardError
            nil
          end
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
          headers = []
          request.headers.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
            headers.append(header[0].downcase.gsub("http_", "").gsub("_", "-"))
          }
          return headers
        rescue StandardError
          nil
        end
      end
    end
  end
end