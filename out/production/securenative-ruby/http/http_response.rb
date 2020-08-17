# frozen_string_literal: true

class HttpResponse
  attr_reader :ok, :status_code, :body
  attr_writer :ok, :status_code, :body

  def initialize(ok, status_code, body)
    @ok = ok
    @status_code = status_code
    @body = body
  end
end
