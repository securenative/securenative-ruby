# frozen_string_literal: true

module SecureNative
  module FrameWorkContext
    class SinatraContext
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
          # Note: At the moment we're filtering out everything but user-agent since ruby's payload is way too big
          {'user-agent' => request.env['HTTP_USER_AGENT']}
        rescue StandardError
          nil
        end
      end
    end
  end
end
