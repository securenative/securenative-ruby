# frozen_string_literal: true

require 'ipaddr'

module SecureNative
  module Utils
    class RequestUtils
      SECURENATIVE_COOKIE = '_sn'
      SECURENATIVE_HEADER = 'x-securenative'
      IP_HEADERS = %w[HTTP_X_FORWARDED_FOR HTTP_X_REAL_IP REMOTE_ADDR x-forwarded-for x-client-ip x-real-ip x-forwarded x-cluster-client-ip forwarded-for forwarded via]
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
        # proxy headers extraction
        unless options.proxy_headers.nil?
          options.proxy_headers.each { |header|
            begin
              header_value = request.env[header]
            rescue NoMethodError
              header_value = request[header]
            rescue NoMethodError
              header_value = request.header[header]
            rescue NoMethodError
              header_value = nil
            end
            unless header_value.nil?
              parsed = self.parse_and_validate_ip(header_value, header)
              unless parsed.nil?
                return parsed
              end
            end
          }
        end

        # extract from IP_HEADERS list
        IP_HEADERS.each { |header|
          begin
            header_value = request.env[header]
          rescue NoMethodError
            header_value = request[header]
          rescue NoMethodError
            header_value = request.header[header]
          rescue NoMethodError
            header_value = nil
          end
          unless header_value.nil?
            parsed = self.parse_and_validate_ip(header_value, header)
            unless parsed.nil?
              return parsed
            end
          end
        }

        begin
          return request.ip unless request.ip.nil?
        rescue NoMethodError
          ''
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

      def self.parse_and_validate_ip(headers, header_key)
        h = headers.gsub(header_key + ': ', '')
        if headers.include? ','
          h = h.split(',')
          h.each { |value|
            if IpUtils.valid_public_ip?(value)
              return value
            end
          }
        end

        if IpUtils.valid_public_ip?(h)
          return h
        end
        if IpUtils.loop_back?(h)
          return h
        end
      end
    end
  end
end
