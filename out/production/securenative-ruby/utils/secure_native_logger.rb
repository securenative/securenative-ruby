# frozen_string_literal: true

require 'logger'

class SecureNativeLogger
  @logger = Logger.new(STDOUT)

  def self.init_logger(level = 'DEBUG')
    @logger.level = case level
                    when 'WARN'
                      SecureNativeLogger::WARN
                    when 'DEBUG'
                      SecureNativeLogger::DEBUG
                    when 'ERROR'
                      SecureNativeLogger::ERROR
                    when 'FATAL'
                      SecureNativeLogger::FATAL
                    when 'INFO'
                      SecureNativeLogger::INFO
                    else
                      SecureNativeLogger::FATAL
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
