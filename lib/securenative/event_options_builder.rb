class EventOptionsBuilder
  MAX_PROPERTIES_SIZE = 10

  def initialize(event_type, user_id, user_traits, user_name, email, created_at, context, properties, timestamp)
    @event_options = EventOptions(event_type)
    @event_options.user_id = user_id
    @event_options.user_traits = user_traits if user_traits
    @event_options.user_traits = UserTraits(name, email, created_at) if user_name && email && created_at
    @event_options.context = context
    @event_options.properties = properties
    @event_options.timestamp = timestamp
  end

  def build
    if !@event_options.properties.nil? && @event_options.properties.length > MAX_PROPERTIES_SIZE
      raise SecureNativeInvalidOptionsException('You can have only up to {} custom properties', MAX_PROPERTIES_SIZE)
    end

    @event_options
  end
end