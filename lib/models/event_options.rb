# frozen_string_literal: true

class EventOptions
  attr_reader :event, :user_id, :user_traits, :context, :properties, :timestamp
  attr_writer :event, :user_id, :user_traits, :context, :properties, :timestamp

  def initialize(event: nil, user_id: nil, user_traits: nil, context: nil, properties: nil, timestamp: nil)
    @event = event
    @user_id = user_id
    @user_traits = user_traits
    @context = context
    @properties = properties
    @timestamp = timestamp
  end
end
