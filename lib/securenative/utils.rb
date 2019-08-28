require_relative 'config'
require "logger"
require "base64"
require "json"
require 'openssl'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN


module Utils
  def self.verify_signature(secret, text_body, header_signature)
    begin
      key = secret.encode('utf-8')
      body = text_body.encode('utf-8')
      calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), key, body)
      calculated_signature.eql? header_signature
    rescue Exception
      return false
    end
  end

  def self.parse_cookie(cookie = nil)
    fp = ""
    cid = ""
    unless cookie
      return fp, cid
    end

    begin
      decoded_cookie = Base64.decode64(cookie)
      unless decoded_cookie
        decoded_cookie = "{}"
      end
      jsonified = JSON.generate(decoded_cookie)
      if jsonified["fp"]
        fp = jsonified["fp"]
      end
      if jsonified["cid"]
        cid = jsonified["cid"]
      end
    rescue Exception
    ensure
      return fp, cid
    end
  end

  def self.decrypt(encrypted, cipher_key)
    decipher = OpenSSL::Cipher::AES.new(Config::CIPHER_SIZE, :CBC).decrypt
    decipher.padding = 0

    begin
      cipher_key = cipher_key.each_byte.map { |b| b.to_s(16) }.join
      encrypted = encrypted.each_byte.map { |b| b.to_s(16) }.join

      decipher.key = cipher_key.slice(0, Config::AES_KEY_SIZE)
      decipher.iv = encrypted.slice(0, Config::AES_BLOCK_SIZE)

      decrypted = decipher.update(encrypted) + decipher.final
      decrypted = decrypted.each_byte.map { |b| b.to_s(16) }.join
      return decrypted
    rescue => err
      logger.fatal("Could not decrypt encrypted data: " + err.message)
      return nil
    end
  end

end