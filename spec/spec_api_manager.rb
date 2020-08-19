# frozen_string_literal: true

require 'api_manager'
require 'webmock/rspec'
require 'config/configuration_builder'
require 'errors/securenative_invalid_options_error'
require 'models/event_options'
require 'models/verify_result'
require 'models/user_traits'
require 'enums/event_types'
require 'enums/risk_level'
require 'event_manager'
require 'rspec'

RSpec.describe ApiManager do
  it 'tracks an event' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', auto_send: true, interval: 10, api_url: 'https://api.securenative-stg.com/collector/api/v1')

    expected = '{"eventType":"sn.user.login","userId":"USER_ID","userTraits":{' \
                   '"name":"USER_NAME","email":"USER_EMAIL","phone":"+1234567890","createdAt":null},"request":{' \
                   '"cid":null,"vid":null,"fp":null,"ip":"127.0.0.1","remoteIp":null,"headers":{' \
                   '"user-agent":"Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) ' \
                   'AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405"},"url":null,"method":null},' \
                   '"properties":{"prop2":true,"prop1":"CUSTOM_PARAM_VALUE","prop3":3}}'

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track')
      .with(body: JSON.parse(expected)).to_return(status: 200)
    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)
    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: 'USER_ID',
                                     user_traits: UserTraits.new(name: 'USER_NAME', email: 'USER_EMAIL', phone: '+1234567890'),
                                     properties: { prop1: 'CUSTOM_PARAM_VALUE', prop2: true, prop3: 3 })

    begin
      api_manager.track(event_options)
    ensure
      event_manager.stop_event_persist
    end
  end

  it 'uses invalid options' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', auto_send: true, interval: 10, api_url: 'https://api.securenative-stg.com/collector/api/v1')

    properties = {}
    (0..12).each do |i|
      properties[i] = i
    end

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track').to_return(status: 200)
    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)

    begin
      expect { api_manager.track(EventOptions.new(event: EventTypes::LOG_IN, properties: properties)) }
        .to raise_error(SecureNativeInvalidOptionsError)
    ensure
      event_manager.stop_event_persist
    end
  end

  it 'verifies an event' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')

    stub_request(:post, 'https://api.securenative-stg.com/collector/api/v1/track')
      .with(body: { riskLevel: 'medium', score: 0.32, triggers: ['New IP', 'New City'] }).to_return(status: 200)
    verify_result = VerifyResult.new(risk_level: RiskLevel::LOW, score: 0, triggers: nil)

    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)
    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: 'USER_ID',
                                     user_traits: UserTraits.new(name: 'USER_NAME', email: 'USER_EMAIL', phone: '+1234567890'),
                                     properties: { prop1: 'CUSTOM_PARAM_VALUE', prop2: true, prop3: 3 })

    result = api_manager.verify(event_options)

    expect(result).not_to be_nil
    expect(result.risk_level).to eq(verify_result.risk_level)
    expect(result.score).to eq(verify_result.score)
    expect(result.triggers).to eq(verify_result.triggers)
  end
end
