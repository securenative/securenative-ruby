# frozen_string_literal: true

require 'models/sdk_event'
require 'models/event_options'
require 'config/securenative_options'
require 'enums/event_types'
require 'errors/securenative_invalid_options_error'
require 'rspec'

RSpec.describe SDKEvent do
  it 'throws when event created without user id' do
    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: nil)
    options = SecureNativeOptions.new

    expect { SDKEvent.new(event_options, options) }.to raise_error(SecureNativeInvalidOptionsError)
  end

  it 'throws when event created without event type' do
    event_options = EventOptions.new(event: nil, user_id: '1234')
    options = SecureNativeOptions.new

    expect { SDKEvent.new(event_options, options) }.to raise_error(SecureNativeInvalidOptionsError)
  end
end
