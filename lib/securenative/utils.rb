require_relative 'config'
require "logger"
require "base64"
require "json"
require 'openssl'


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

  def self.encrypt(plain_text, key)
    cipher = OpenSSL::Cipher::AES.new(Config::CIPHER_SIZE, :CBC).encrypt
    cipher.padding = 0

    if plain_text.size % Config::AES_BLOCK_SIZE != 0
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      logger.fatal("data not multiple of block length")
      return nil
    end

    key = Digest::SHA1.hexdigest key
    cipher.key = key.slice(0, Config::AES_BLOCK_SIZE)
    s = cipher.update(plain_text) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def self.decrypt(encrypted, key)
    cipher = OpenSSL::Cipher::AES.new(Config::CIPHER_SIZE, :CBC).decrypt
    cipher.padding = 0

    key = Digest::SHA1.hexdigest key
    cipher.key = key.slice(0, Config::AES_BLOCK_SIZE)
    s = [encrypted].pack("H*").unpack("C*").pack("c*")

    rv = cipher.update(s) + cipher.final
    return rv.strip
  end
end