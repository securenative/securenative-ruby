# frozen_string_literal: true

require 'ipaddr'

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
              parsed = self.parse_proxy_header(h, header)
              if self.validate_ip(parsed)
                return parsed
              end
            rescue NoMethodError
              begin
                h = request[header]
                if h.nil?
                  h = request.env[self.parse_ip(header)]
                end
                parsed = self.parse_proxy_header(h, header)
                if self.validate_ip(parsed)
                  return parsed
                end
              rescue NoMethodError
                # Ignored
              end
            end
          }
        end

        begin
          x_forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
          if ip.include? ','
            x_forwarded_for = ip.split(',')[0]
          end
          if self.validate_ip(x_forwarded_for)
            return x_forwarded_for
          end
        rescue NoMethodError
          begin
            x_forwarded_for = request['HTTP_X_FORWARDED_FOR']
            if ip.include? ','
              x_forwarded_for = ip.split(',')[0]
            end
            if self.validate_ip(x_forwarded_for)
              return x_forwarded_for
            end
          rescue NoMethodError
            # Ignored
          end
        end

        begin
          x_forwarded_for = request.env['HTTP_X_REAL_IP']
          if ip.include? ','
            x_forwarded_for = ip.split(',')[0]
          end
          if self.validate_ip(x_forwarded_for)
            return x_forwarded_for
          end
        rescue NoMethodError
          begin
            x_forwarded_for = request['HTTP_X_REAL_IP']
            if ip.include? ','
              x_forwarded_for = ip.split(',')[0]
            end
            if self.validate_ip(x_forwarded_for)
              return x_forwarded_for
            end
          rescue NoMethodError
            # Ignored
          end
        end

        begin
          x_forwarded_for = request.env['REMOTE_ADDR']
          if ip.include? ','
            x_forwarded_for = ip.split(',')[0]
          end
          if self.validate_ip(x_forwarded_for)
            return x_forwarded_for
          end
        rescue NoMethodError
          begin
            x_forwarded_for = request['REMOTE_ADDR']
            if ip.include? ','
              x_forwarded_for = ip.split(',')[0]
            end
            if self.validate_ip(x_forwarded_for)
              return x_forwarded_for
            end
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

      def self.parse_proxy_header(headers, header_key)
        h = headers.gsub(header_key + ': ', '')
        if headers.include? ','
          h = h.split(',')[0]
        end
        return h
      end

      def self.validate_ip(ip)
        if ip.nil?
          return false
        end

        begin
          ipaddr = IPAddr.new(ip)
          if ipaddr.ipv4?
            return true
          end

          if ipaddr.ipv6?
            return true
          end
        rescue Exception
          # Ignored
        end

        return false
      end
    end
  end
end
