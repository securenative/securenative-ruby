# frozen_string_literal: true

module SecureNative
  module Utils
    class RequestUtils
      SECURENATIVE_COOKIE = '_sn'
      SECURENATIVE_HEADER = 'x-securenative'
      PREFIX = 'HTTP_'

      def self.get_secure_header_from_request(headers)
        begin
          return headers[SECURENATIVE_HEADER] unless headers.nil?
        rescue StandardError
          []
        end
        []
      end

      def self.get_client_ip_from_request(request, options)
        unless options.proxy_headers.nil?
          options.proxy_headers.each { |header|
            begin
              h = request.env[header]
              if h.nil?
                h = request.env[self.parse_ip(header)]
              end
              return h.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless h.nil?
            rescue NoMethodError
              begin
                h = request[header]
                if h.nil?
                  h = request.env[self.parse_ip(header)]
                end
                return h.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless h.nil?
              rescue NoMethodError
                # Ignored
              end
            end
          }
        end

        begin
          x_forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
          return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
        rescue NoMethodError
          begin
            x_forwarded_for = request['HTTP_X_FORWARDED_FOR']
            return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
          rescue NoMethodError
            # Ignored
          end
        end

        begin
          x_forwarded_for = request.env['HTTP_X_REAL_IP']
          return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
        rescue NoMethodError
          begin
            x_forwarded_for = request['HTTP_X_REAL_IP']
            return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
          rescue NoMethodError
            # Ignored
          end
        end

        begin
          x_forwarded_for = request.env['REMOTE_ADDR']
          return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
        rescue NoMethodError
          begin
            x_forwarded_for = request['REMOTE_ADDR']
            return x_forwarded_for.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)[0] unless x_forwarded_for.nil?
          rescue NoMethodError
            # Ignored
          end
        end

        begin
          return request.ip unless request.ip.nil?
        rescue NoMethodError
          # Ignored
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

      def self.parse_ip(headers)
        h = headers.gsub('-', '_')
        return PREFIX + h.upcase
      end
    end
  end
end
