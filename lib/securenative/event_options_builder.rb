class EventOptionsBuilder
  MAX_PROPERTIES_SIZE = 10

  def initialize(event_type, user_id, user_traits, user_name, email, phone, created_at, context, properties, timestamp)
    traits = UserTraits(user_name)
    if user_name && email && phone && created_at
      traits = UserTraits(user_name, email, phone, created_at)
    elsif user_name && email && phone
      traits = UserTraits(user_name, email, phone)
    elsif user_name && email
      traits = UserTraits(user_name, email)
    end

    @event_options = EventOptions(event_type)
    @event_options.user_id = user_id
    @event_options.user_traits = user_traits if user_traits
    @event_options.user_traits = traits
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