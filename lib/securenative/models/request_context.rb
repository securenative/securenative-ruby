# frozen_string_literal: true

module SecureNative
  class RequestContext
    attr_reader :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :http_method
    attr_writer :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :http_method

    def initialize(cid: nil, vid: nil, fp: nil, ip: nil, remote_ip: nil, headers: nil, url: nil, http_method: nil)
      @cid = cid
      @vid = vid
      @fp = fp
      @ip = ip
      @remote_ip = remote_ip
      @headers = headers
      @url = url
      @method = http_method
    end
  end
end

