class RequestOptions
  attr_reader :url, :body, :retry
  attr_writer :url, :body, :retry

  def initialize(url, body, _retry)
    @url = url
    @body = body
    @retry = _retry
  end
end