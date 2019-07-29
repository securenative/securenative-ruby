require_relative 'event_options'
require_relative 'event_type'

class EventBuilder
  def build(type = EventType::LOG_IN, id)
    Event.new(event_type = type,
              user = User.new(user_id = id, user_email = 'support@securenative.com', user_name = 'support'),
              params = [CustomParam.new('key', 'val')]
    )
  end
end
