# frozen_string_literal: true

require 'logger'

module SecureNative
  class Log
    @logger = Logger.new(STDOUT)

    def self.init_logger(level = 'DEBUG')
      @logger.level = case level
                      when 'WARN'
                        Logger::WARN
                      when 'DEBUG'
                        Logger::DEBUG
                      when 'ERROR'
                        Logger::ERROR
                      when 'FATAL'
                        Logger::FATAL
                      when 'INFO'
                        Logger::INFO
                      else
                        Logger::FATAL
                      end

      @logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{severity}  (#{progname}): #{msg}\n"
      end
    end

    def self.info(msg)
      @logger.info(msg)
    end

    def self.debug(msg)
      @logger.debug(msg)
    end

    def self.warning(msg)
      @logger.warning(msg)
    end

    def self.error(msg)
      @logger.error(msg)
    end
  end
end
