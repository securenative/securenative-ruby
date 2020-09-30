# frozen_string_literal: true

module SecureNative
  class EventOptions
    attr_reader :event, :user_id, :user_traits, :context, :properties, :timestamp
    attr_writer :event, :user_id, :user_traits, :context, :properties, :timestamp

    MAX_PROPERTIES_SIZE = 10

    def initialize(event: nil, user_id: nil, user_traits: nil, user_name: nil, email: nil, phone: nil, created_at: nil, context: nil, properties: nil, timestamp: nil)
      if !properties.nil? && properties.length > MAX_PROPERTIES_SIZE
        raise SecureNativeInvalidOptionsError, "You can have only up to #{MAX_PROPERTIES_SIZE} custom properties"
      end

      if user_traits.nil?
        if user_name && email && phone && created_at
          user_traits = SecureNative::UserTraits(user_name, email, phone, created_at)
        elsif user_name && email && phone
          user_traits = SecureNative::UserTraits(user_name, email, phone)
        elsif user_name && email
          user_traits = SecureNative::UserTraits(user_name, email)
        else
          user_traits = UserTraits.new
        end
      end

      @event = event
      @user_id = user_id
      @user_traits = user_traits
      @context = context
      @properties = properties
      @timestamp = timestamp
    end
  end
end
