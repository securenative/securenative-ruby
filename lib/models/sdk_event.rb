# frozen_string_literal: true

require 'context/securenative_context'
require 'utils/encryption_utils'

class SDKEvent
  attr_reader :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties
  attr_writer :context, :rid, :event_type, :user_id, :user_traits, :request, :timestamp, :properties

  def initialize(event_options, securenative_options)
    @context = if !event_options.context.nil?
                 event_options.context
               else
                 SecureNativeContext.default_context_builder
               end

    client_token = EncryptionUtils.decrypt(@context.client_token, securenative_options.api_key)

    @rid = SecureRandom.uuid.to_str
    @event_type = event_options.event
    @user_id = event_options.user_id
    @user_traits = event_options.user_traits
    @request = RequestContext(client_token ? client_token.cid : '', client_token ? client_token.vid : '',
                              client_token ? client_token.fp : '', @context.ip,
                              @context.remote_ip, @context.headers, @context.url, @context.http_method)

    @timestamp = DateUtils.to_timestamp(event_options.timestamp)
    @properties = event_options.properties
  end

  def to_s
    "context: #{@context}, rid: #{@rid}, event_type: #{@event_type}, user_id: #{@user_id},
    user_traits: #{@user_traits}, request: #{@request}, timestamp: #{@timestamp}, properties: #{@properties}"
  end
end
