class SdkEvent
  attr_reader :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties
  attr_writer :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties

  def initialize(event_options, securenative_options)
    if !event_options.context.nil?
      @context = event_options.context
    else
      @context = ContextBuilder.default_context_builder.build
    end

    client_token = EncryptionUtils.decrypt(@context.client_token, securenative_options.api_key)

    @rid = SecureRandom.uuid.to_str
    @event_type = event_options.event
    @user_id = event_options.user_id
    @user_traits = event_options.user_traits
    @request = RequestContextBuilder()
                   .with_cid(client_token ? client_token.cid : "")
                   .with_vid(client_token ? client_token.vid : "")
                   .with_fp(client_token ? client_token.fp : "")
                   .with_ip(@context.ip)
                   .with_remote_ip(@context.remote_ip)
                   .with_method(@context.method)
                   .with_url(@context.url)
                   .with_headers(@context.headers)
                   .build

    @timestamp = DateUtils.to_timestamp(event_options.timestamp)
    @properties = event_options.properties
  end
end