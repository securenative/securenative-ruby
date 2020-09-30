# frozen_string_literal: true

class SignatureUtils
  SIGNATURE_HEADER = 'x-securenative'

  def self.valid_signature?(api_key, payload, header_signature)
    key = api_key.encode('utf-8')
    body = payload.encode('utf-8')
    calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), key, body)
    calculated_signature.eql? header_signature
  rescue StandardError
    false
  end
end
