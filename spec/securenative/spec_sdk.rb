# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SecureNative::Client do
  it 'gets sdk instance without init throws' do
    SecureNative::Client._flush
    expect { SecureNative::Client.instance }.to raise_error(SecureNativeSDKIllegalStateError)
  end

  it 'inits sdk without api key and throws' do
    expect { SecureNative::Client.init_with_options(SecureNative::Config::ConfigurationManager.config_builder) }.to raise_error(SecureNativeSDKError)
  end

  it 'inits sdk with empty api key and throws' do
    expect { SecureNative::Client.init_with_api_key('') }.to raise_error(SecureNativeConfigError)
  end

  it 'inits sdk with api key and defaults' do
    SecureNative::Client._flush
    api_key = "API_KEY"
    securenative = SecureNative::Client.init_with_api_key(api_key)
    options = securenative.options

    expect(options.api_key).to eq(api_key)
    expect(options.api_url).to eq('https://api.securenative.com/collector/api/v1')
    expect(options.interval).to eq(1000)
    expect(options.timeout).to eq(1500)
    expect(options.max_events).to eq(1000)
    expect(options.auto_send).to eq(true)
    expect(options.disable).to eq(false)
    expect(options.log_level).to eq('FATAL')
    expect(options.fail_over_strategy).to eq(SecureNative::FailOverStrategy::FAIL_OPEN)
  end

  it 'inits sdk twice and throws' do
    expect { SecureNative::Client.init_with_api_key('API_KEY') }.to raise_error(SecureNativeSDKError)
  end

  it 'inits sdk with api key and gets instance' do
    SecureNative::Client._flush
    api_key = 'API_KEY'
    securenative = SecureNative::Client.init_with_api_key(api_key)

    expect(securenative).to eq(SecureNative::Client.instance)
  end

  it 'inits sdk with builder' do
    SecureNative::Client._flush
    securenative = SecureNative::Client.init_with_options(SecureNative::Config::ConfigurationBuilder.new(api_key: 'API_KEY', max_events: 10, log_level: 'ERROR'))
    options = securenative.options

    expect(options.api_key).to eq('API_KEY')
    expect(options.max_events).to eq(10)
    expect(options.log_level).to eq('ERROR')
  end
end
