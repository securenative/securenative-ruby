# frozen_string_literal: true

require 'securenative/models/sdk_event'
require 'securenative/models/event_options'
require 'securenative/config/securenative_options'
require 'securenative/enums/event_types'
require 'securenative/errors/securenative_invalid_options_error'
require 'rspec'

RSpec.describe SecureNative::SDKEvent do
  it 'throws when event created without user id' do
    event_options = SecureNative::EventOptions.new(event: SecureNative::EventTypes::LOG_IN, user_id: nil)
    options = SecureNative::SecureNativeOptions.new

    expect { SecureNative::SDKEvent.new(event_options, options) }.to raise_error(SecureNative::SecureNativeInvalidOptionsError)
  end

  it 'throws when event created without event type' do
    event_options = SecureNative::EventOptions.new(event: nil, user_id: '1234')
    options = SecureNative::SecureNativeOptions.new

    expect { SecureNative::SDKEvent.new(event_options, options) }.to raise_error(SecureNative::SecureNativeInvalidOptionsError)
  end
end
