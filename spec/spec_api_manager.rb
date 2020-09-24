# frozen_string_literal: true

require 'securenative/api_manager'
require 'webmock/rspec'
require 'securenative/config/configuration_builder'
require 'securenative/errors/securenative_invalid_options_error'
require 'securenative/models/event_options'
require 'securenative/models/verify_result'
require 'securenative/models/user_traits'
require 'securenative/enums/event_types'
require 'securenative/enums/risk_level'
require 'securenative/event_manager'
require 'rspec'

RSpec.describe SecureNative::ApiManager do
  it 'tracks an event' do
    options = SecureNative::ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', auto_send: true, interval: 10, api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track').to_return(status: 200)
    event_manager = SecureNative::EventManager.new(options)
    event_manager.start_event_persist
    api_manager = SecureNative::ApiManager.new(event_manager, options)
    event_options = SecureNative::EventOptions.new(event: SecureNative::EventTypes::LOG_IN, user_id: 'USER_ID',
                                                   user_traits: SecureNative::UserTraits.new(name: 'USER_NAME', email: 'USER_EMAIL', phone: '+1234567890'),
                                                   properties: { prop1: 'CUSTOM_PARAM_VALUE', prop2: true, prop3: 3 })

    begin
      res = api_manager.track(event_options)
    ensure
      event_manager.stop_event_persist
    end

    expect(res).to_not be_nil
  end

  it 'uses invalid options' do
    options = SecureNative::ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', auto_send: true, interval: 10, api_url: 'https://api.securenative-stg.com/collector/api/v1')

    properties = {}
    (0..12).each do |i|
      properties[i] = i
    end

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track').to_return(status: 200)
    event_manager = SecureNative::EventManager.new(options)
    event_manager.start_event_persist
    api_manager = SecureNative::ApiManager.new(event_manager, options)

    begin
      expect { api_manager.track(SecureNative::EventOptions.new(event: SecureNative::EventTypes::LOG_IN, properties: properties)) }
        .to raise_error(SecureNative::SecureNativeInvalidOptionsError)
    ensure
      event_manager.stop_event_persist
    end
  end

  it 'verifies an event' do
    options = SecureNative::ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/verify').with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'YOUR_API_KEY',
        'Content-Type' => 'application/json',
        'Sn-Version' => '0.1.26',
        'User-Agent' => 'SecureNative-ruby'
      }
    ).to_return(status: 200, body: '', headers: {})

    event_manager = SecureNative::EventManager.new(options)
    event_manager.start_event_persist
    api_manager = SecureNative::ApiManager.new(event_manager, options)
    event_options = SecureNative::EventOptions.new(event: SecureNative::EventTypes::LOG_IN, user_id: 'USER_ID',
                                                   user_traits: SecureNative::UserTraits.new(name: 'USER_NAME', email: 'USER_EMAIL', phone: '+1234567890'),
                                                   properties: { prop1: 'CUSTOM_PARAM_VALUE', prop2: true, prop3: 3 })

    result = api_manager.verify(event_options)

    expect(result).not_to be_nil
    expect(result.risk_level).to eq('low')
    expect(result.score).to eq(0)
    expect(result.triggers).to eq(nil)
  end
end
