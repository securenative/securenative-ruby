require 'openssl'

class SignatureUtils
  def self.is_valid_signature(api_key, payload, header_signature)
    begin
      key = api_key.encode('utf-8')
      body = payload.encode('utf-8')
      calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), key, body)
      calculated_signature.eql? header_signature
    rescue Exception
      return false
    end
  end
end