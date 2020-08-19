# frozen_string_literal: true

class RequestOptions
  attr_reader :url, :body, :retry_sending
  attr_writer :url, :body, :retry_sending

  def initialize(url, body, retry_sending)
    @url = url
    @body = body
    @retry_sending = retry_sending
  end
end
