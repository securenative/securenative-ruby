# frozen_string_literal: true

module SecureNative
  module Frameworks
    class Hanami
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
          request.env['REQUEST_PATH']
        rescue StandardError
          nil
        end
      end

      def self.get_method(request)
        begin
          request.request_method
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
