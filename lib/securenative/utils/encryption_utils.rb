# frozen_string_literal: true

require 'openssl'
require 'digest'
require 'base64'
require 'securenative/models/client_token'

module SecureNative
  class EncryptionUtils
    def self.padding_key(key, length)
      if key.length == length
        key
      else
        if key.length > length
          key.slice(0, length)
        else
          (length - key.length).times { key << '0' }
          key
        end
      end
    end

    def self.encrypt(plain_text, secret_key)
      begin
        cipher = OpenSSL::Cipher.new('aes-256-cbc')
        cipher.encrypt
        iv = cipher.random_iv
        cipher.key = padding_key(secret_key, 32)
        encrypted = cipher.update(plain_text) + cipher.final
        (iv + encrypted).unpack1('H*')
      rescue StandardError
        ''
      end
    end

    def self.decrypt(cipher_text, secret_key)
      begin
        cipher = OpenSSL::Cipher.new('aes-256-cbc')
        cipher.decrypt
        raw_data = [cipher_text].pack('H*')
        cipher.iv = raw_data.slice(0, 16)
        cipher.key = padding_key(secret_key, 32)
        decrypted = JSON.parse(cipher.update(raw_data.slice(16, raw_data.length)) + cipher.final)

        return ClientToken.new(decrypted['cid'], decrypted['vid'], decrypted['fp'])
      rescue StandardError
        ClientToken.new('', '', '')
      end
    end
  end
end
