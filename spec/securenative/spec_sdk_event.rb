# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SecureNative::SDKEvent do
  it 'throws when event created without user id' do
    event_options = SecureNative::EventOptions.new(event: SecureNative::EventTypes::LOG_IN, user_id: nil)
    options = SecureNative::Options.new

    expect { SecureNative::SDKEvent.new(event_options, options) }.to raise_error(SecureNativeInvalidOptionsError)
  end

  it 'throws when event created without event type' do
    event_options = SecureNative::EventOptions.new(event: nil, user_id: '1234')
    options = SecureNative::Options.new

    expect { SecureNative::SDKEvent.new(event_options, options) }.to raise_error(SecureNativeInvalidOptionsError)
  end
end
