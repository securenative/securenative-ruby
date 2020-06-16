require 'logger'

class Logger
  @logger = Logger.new(STDOUT)

  def self.init_logger(level)
    case level
    when "WARN"
      @logger.level = Logger::WARN
    when "DEBUG"
      @logger.level = Logger::DEBUG
    when "ERROR"
      @logger.level = Logger::ERROR
    when "FATAL"
      @logger.level = Logger::FATAL
    when "INFO"
      @logger.level = Logger::INFO
    else
      @logger.level = Logger::FATAL
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