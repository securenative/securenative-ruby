require_relative 'securenative/sn_exception'
require_relative 'securenative/secure_native_sdk'
require 'logger'

$securenative = nil
$logger = Logger.new(STDOUT)
$logger.level = Logger::INFO

module SecureNative
  def self.init(api_key, options: SecureNativeOptions.new)
    if $securenative == nil
      $securenative = SecureNativeSDK.new(api_key, options: options)
    else
      $logger.info("This SDK was already initialized")
      raise StandardError.new("This SDK was already initialized")
    end
  end

  def self.track(event)
    sdk = _get_or_throw
    sdk.track(event)
  end

  def self.verify(event)
    sdk = _get_or_throw
    sdk.verify(event)
  end

  def self.verify_webhook(hmac_header, body)
    sdk = _get_or_throw
    sdk.verify_webhook(hmac_header = hmac_header, body = body)
  end

  def self.flush
    sdk = _get_or_throw
    sdk.flush
  end

  def self._get_or_throw
    if $securenative == nil
      raise SecureNativeSDKException.new
    end
    $securenative
  end
end