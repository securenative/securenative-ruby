require_relative '../../lib/securenative/securenative_options'
require_relative '../../lib/securenative/http_client'
require_relative '../../lib/securenative/sn_exception'
require 'json'
require 'thread'

class QueueItem
  def initialize(url, body)
    @url = url
    @body = body
  end

  attr_reader :url
  attr_reader :body
end

class EventManager
  def initialize(api_key, options: SecureNativeOptions.new, http_client: HttpClient.new)
    if api_key == nil
      raise SecureNativeSDKException.new
    end

    @api_key = api_key
    @options = options
    @http_client = http_client
    @queue = Queue.new

    if @options.auto_send
      interval_seconds = [(@options.interval / 1000).floor, 1].max
      Thread.new do
        loop do
          flush
          sleep(interval_seconds)
        end
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
        event.to_hash.to_json
    )
  end

  def flush
    if is_queue_full
      i = @options.max_events - 1
      while i >= 0
        item = @queue.pop
        @http_client.post(
            build_url(item.url),
            @api_key,
            item.body.to_hash.to_json
        )
      end
    else
      q = Array.new(@queue.size) {@queue.pop}
      q.each do |item|
        @http_client.post(
            build_url(item.url),
            @api_key,
            item.body
        )
        @queue = Queue.new
      end
    end
  end

  private

  def build_url(path)
    @options.api_url + path
  end

  private

  def is_queue_full
    @queue.length > @options.max_events
  end

end