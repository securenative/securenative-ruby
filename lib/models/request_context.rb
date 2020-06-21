class RequestContext
  attr_reader :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :method
  attr_writer :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :method

  def initialize(cid = nil, vid = nil, fp = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, method = nil)
    @cid = cid
    @vid = vid
    @fp = fp
    @ip = ip
    @remote_ip = remote_ip
    @headers = headers
    @url = url
    @method = method
  end
end

class RequestContextBuilder
  attr_reader :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :method
  attr_writer :cid, :vid, :fp, :ip, :remote_ip, :headers, :url, :method

  def initialize(cid = nil, vid = nil, fp = nil, ip = nil, remote_ip = nil, headers = nil, url = nil, method = nil)
    @cid = cid
    @vid = vid
    @fp = fp
    @ip = ip
    @remote_ip = remote_ip
    @headers = headers
    @url = url
    @method = method
  end

  def with_cid(cid)
    @cid = cid
    self
  end

  def with_vid(vid)
    @vid = vid
    self
  end

  def with_fp(fp)
    @fp = fp
    self
  end

  def with_ip(ip)
    @ip = ip
    self
  end

  def with_remote_ip(remote_ip)
    @remote_ip = remote_ip
    self
  end

  def with_headers(headers)
    @headers = headers
    self
  end

  def with_url(url)
    @url = url
    self
  end

  def with_method(method)
    @method = method
    self
  end

  def build
    RequestContext(@cid, @vid, @fp, @ip, @remote_ip, @headers, @url, @method)
  end
end
