class EventOptionsBuilder
  MAX_PROPERTIES_SIZE = 10

  def initialize(event_type)
    @event_options = EventOptions(event_type)
  end

  def with_user_id(user_id)
    @event_options.user_id = user_id
    self
  end

  def with_user_traits(user_traits)
    @event_options.user_traits = user_traits
    self
  end

  def with_user(name, email, created_at = nil)
    @event_options.user_traits = UserTraits(name, email, created_at)
    self
  end

  def with_context(context)
    @event_options.context = context
    self
  end

  def with_properties(properties)
    @event_options.properties = properties
    self
  end

  def with_timestamp(timestamp)
    @event_options.timestamp = timestamp
    self
  end

  def build
    if !@event_options.properties.nil? && @event_options.properties.length > MAX_PROPERTIES_SIZE
      raise SecureNativeInvalidOptionsException('You can have only up to {} custom properties', MAX_PROPERTIES_SIZE)
    end

    @event_options
  end
end