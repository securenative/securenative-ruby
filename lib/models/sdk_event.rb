# frozen_string_literal: true

class SDKEvent
  attr_reader :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties
  attr_writer :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties

  def initialize(event_options, securenative_options)
    @context = if !event_options.context.nil?
                 event_options.context
               else
                 ContextBuilder.default_context_builder
               end

    client_token = EncryptionUtils.decrypt(@context.client_token, securenative_options.api_key)

    @rid = SecureRandom.uuid.to_str
    @event_type = event_options.event
    @user_id = event_options.user_id
    @user_traits = event_options.user_traits
    @request = RequestContext(cid = client_token ? client_token.cid : '', vid = client_token ? client_token.vid : '',
                              fp = client_token ? client_token.fp : '', ip = @context.ip,
                              remote_ip = @context.remote_ip, method = @context.http_method, url = @context.url,
                              headers = @context.headers)

    @timestamp = DateUtils.to_timestamp(event_options.timestamp)
    @properties = event_options.properties
  end
end
