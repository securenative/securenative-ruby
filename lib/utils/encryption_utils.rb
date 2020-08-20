# frozen_string_literal: true

require 'openssl'
require 'models/client_token'

class EncryptionUtils
  BLOCK_SIZE = 16
  KEY_SIZE = 32

  def self.encrypt(text, cipher_key)
    begin
      cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, :CBC).encrypt
      cipher.padding = 0

      if text.size % BLOCK_SIZE != 0
        return nil
      end

      cipher_key = Digest::SHA1.hexdigest cipher_key
      cipher.key = cipher_key.slice(0, BLOCK_SIZE)
      s = cipher.update(text) + cipher.final

      s.unpack('H*')[0].upcase
    rescue StandardError
      ''
    end
  end

  def self.decrypt(encrypted, cipher_key)
    begin
      cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, :CBC).decrypt
      cipher.padding = 0

      cipher_key = Digest::SHA1.hexdigest cipher_key
      cipher.key = cipher_key.slice(0, BLOCK_SIZE)
      s = [encrypted].pack('H*').unpack('C*').pack('c*')

      rv = cipher.update(s) + cipher.final
      rv.strip
    rescue StandardError
      ClientToken.new('', '', '')
    end
  end
end
