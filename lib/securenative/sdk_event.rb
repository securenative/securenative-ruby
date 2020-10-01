# frozen_string_literal: true

module SecureNative
  class SDKEvent
    attr_reader :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties
    attr_writer :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties

    def initialize(event_options, securenative_options)
      if event_options.user_id.nil? || event_options.user_id.length <= 0 || event_options.user_id == ''
        raise SecureNativeInvalidOptionsError.new, 'Invalid event structure; User Id is missing'
      end

      if event_options.event.nil? || event_options.event.length <= 0 || event_options.event == ''
        raise SecureNativeInvalidOptionsError.new, 'Invalid event structure; Event Type is missing'
      end

      @context = if !event_options.context.nil?
                   event_options.context
                 else
                   Context.default_context_builder
                 end

      client_token = SecureNative::Utils::EncryptionUtils.decrypt(@context.client_token, securenative_options.api_key)

      @rid = SecureRandom.uuid.to_str
      @event_type = event_options.event
      @user_id = event_options.user_id
      @user_traits = event_options.user_traits
      @request = RequestContext.new(cid: client_token ? client_token.cid : '', vid: client_token ? client_token.vid : '',
                                    fp: client_token ? client_token.fp : '', ip: @context.ip,
                                    remote_ip: @context.remote_ip, headers: @context.headers,
                                    url: @context.url, http_method: @context.http_method)


      @timestamp = SecureNative::Utils::DateUtils.to_timestamp(event_options.timestamp)
      @properties = event_options.properties
    end

    def to_s
      "context: #{@context}, rid: #{@rid}, event_type: #{@event_type}, user_id: #{@user_id},
    user_traits: #{@user_traits}, request: #{@request}, timestamp: #{@timestamp}, properties: #{@properties}"
    end
  end
end
