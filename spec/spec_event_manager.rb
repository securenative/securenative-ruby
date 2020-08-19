# frozen_string_literal: true

require 'event_manager'
require 'config/configuration_builder'
require 'models/user_traits'
require 'models/request_context'
require 'rspec'
require 'webmock/rspec'

class SampleEvent
  attr_reader :event_type, :timestamp, :rid, :user_id, :user_traits, :request, :properties

  def initialize
    @event_type = 'custom-event'
    @timestamp = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%Z')
    @rid = '432532'
    @user_id = '1'
    @user_traits = UserTraits.new(name: 'some user', email: 'email@securenative.com', phone: '+1234567890')
    @request = RequestContext.new
    @properties = []
  end
end

RSpec.describe EventManager do
  it 'successfully sends sync event with status code 200' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')
    event = SampleEvent.new

    res_body = '{"data": true}'
    stub_request(:any, 'http://api.securenative-stg.com:443/collector/api/v1/some-path/to-api')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'YOUR_API_KEY',
              'Content-Type' => 'application/json',
              'Sn-Version' => '0.1.19',
              'User-Agent' => 'SecureNative-ruby'
            }).to_return(status: 200, body: '', headers: {})
    event_manager = EventManager.new(options)

    event_manager.start_event_persist
    res = event_manager.send_sync(event, 'some-path/to-api', false)
    event_manager.stop_event_persist

    expect(res.code).to eq('200')
  end

  it 'fails when send sync event status code is 401' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')
    event = SampleEvent.new

    stub_request(:any, 'http://api.securenative-stg.com:443/collector/api/v1/some-path/to-api')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'YOUR_API_KEY',
              'Content-Type' => 'application/json',
              'Sn-Version' => '0.1.19',
              'User-Agent' => 'SecureNative-ruby'
            }).to_return(status: 401, body: '', headers: {})

    event_manager = EventManager.new(options)
    res = event_manager.send_sync(event, 'some-path/to-api', false)

    expect(res.code).to eq('401')
  end

  it 'fails when send sync event status code is 500' do
    options = ConfigurationBuilder.new(api_key: 'YOUR_API_KEY', api_url: 'https://api.securenative-stg.com/collector/api/v1')
    event = SampleEvent.new

    stub_request(:post, 'http://api.securenative-stg.com:443/collector/api/v1/some-path/to-api')
      .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'YOUR_API_KEY',
              'Content-Type' => 'application/json',
              'Sn-Version' => '0.1.19',
              'User-Agent' => 'SecureNative-ruby'
            }).to_return(status: 500, body: '', headers: {})
    event_manager = EventManager.new(options)
    res = event_manager.send_sync(event, 'some-path/to-api', false)

    expect(res.code).to eq('500')
  end
end
