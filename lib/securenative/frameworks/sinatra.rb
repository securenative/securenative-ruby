# frozen_string_literal: true

module SecureNative
  module Frameworks
    class Sinatra
      SECURENATIVE_COOKIE = '_sn'

      def self.get_client_token(request)
        begin
          request.env[SECURENATIVE_COOKIE]
        rescue StandardError
          begin
            request.cookies[SECURENATIVE_COOKIE]
          rescue StandardError
            nil
          end
        end
      end

      def self.get_url(request)
        begin
          request.env['REQUEST_URI']
        rescue StandardError
          nil
        end
      end

      def self.get_method(request)
        begin
          request.env['REQUEST_METHOD']
        rescue StandardError
          nil
        end
      end

      def self.get_headers(request)
        begin
          headers = []
          request.headers.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) }.each { |header|
            headers.append(header[0].downcase.gsub("_", "-"))
          }
          headers.append({'user-agent' => request.env['HTTP_USER_AGENT']})

          return headers
        rescue StandardError
          nil
        end
      end
    end
  end
end
