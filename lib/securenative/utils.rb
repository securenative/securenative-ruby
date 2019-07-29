require "base64"
require "json"

module Utils
  def verify_signature(secret, text_body, header_signature)
    begin
      key = secret.encode('utf-8')
      body = text_body.encode('utf-8')
      calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), key, body)
      calculated_signature.eql? header_signature
    rescue Exception
      return false
    end
  end

  def parse_cookie(cookie = nil)
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
end