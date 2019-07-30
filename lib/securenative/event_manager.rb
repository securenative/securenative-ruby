require_relative '../../lib/securenative/securenative_options'
require_relative '../../lib/securenative/http_client'
require_relative '../../lib/securenative/sn_exception'
require 'json'

class QueueItem
  def initialize(url, body)
    @url = url
    @body = body
  end

  attr_reader :url
  attr_reader :body
end

class EventManager
  def initialize(api_key, options = SecureNativeOptions.new, http_client = HttpClient.new)
    if api_key == nil
      raise SecureNativeSDKException.new
    end

    @api_key = api_key
    @options = options
    @http_client = http_client
    @queue = Queue.new

    if @options.auto_send
      Thread.new do
      #  TODO implement me
      end
    end
  end

  def send_async(event, path)
    q_item = QueueItem.new(build_url(path), event)
    @queue.push(q_item)
  end

  def send_sync(event, path)
    @http_client.post(
        build_url(path),
        @api_key,
        JSON.generate(event)
    )
  end

  def flush
    q = Array.new(@queue.size) {@queue.pop}
    @queue = Queue.new

    q.each do |item|
      @http_client.post(
          build_url(item.url),
          @api_key,
          item.body
      )
    end
  end

  private

  def build_url(path)
    @options.api_url + "/" + path
  end

end