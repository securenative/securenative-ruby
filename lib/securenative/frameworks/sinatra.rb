# frozen_string_literal: true

module SecureNative
  module Frameworks
    class Sinatra
      SECURENATIVE_COOKIE = '_sn'
      PII_HEADERS = %w[authorization access_token apikey password passwd secret api_key]

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

      def self.get_headers(request, options)
        begin
          headers = {}
          if !options.pii_headers.nil?
            request.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
              if !header.downcase.in?(options.pii_headers) && !header.upcase.in?(options.pii_headers)
                headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
              end
            }

            if headers.length == 0
              request.headers.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
                if !header.downcase.in?(options.pii_headers) && !header.upcase.in?(options.pii_headers)
                  headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
                end
              }
            end
          elsif options.pii_regex_pattern.nil?
            request.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
              unless options.pii_regex_pattern.match(header)
                headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
              end
            }

            if headers.length == 0
              request.headers.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
                unless options.pii_regex_pattern.match(header)
                  headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
                end
              }
            end
          else
            request.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
              if !header.downcase.in?(PII_HEADERS) && !header.upcase.in?(PII_HEADERS)
                headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
              end
            }

            if headers.length == 0
              request.headers.env.select { |k, _| k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/ }.each { |header|
                if !header.downcase.in?(PII_HEADERS) && !header.upcase.in?(PII_HEADERS)
                  headers[header[0].downcase.gsub("http_", "").gsub("_", "-")] = header[1]
                end
              }
            end
          end
          return headers
        rescue StandardError
          nil
        end
      end
    end
  end
end
