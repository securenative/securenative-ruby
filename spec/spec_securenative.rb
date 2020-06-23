# frozen_string_literal: true

describe SecureNative do
  it 'gets sdk instance without init throws' do
    expect { SecureNative.instance }.to raise_error(SecureNativeSDKIllegalStateException)
  end

  it 'inits sdk without api key and throws' do
    expect { SecureNative.init_with_options(ConfigurationManager.config_builder) }.to raise_error(SecureNativeSDKException)
  end

  it 'inits sdk with empty api key and throws' do
    expect { SecureNative.init_with_api_key('') }.to raise_error(SecureNativeSDKException)
  end

  it 'inits sdk with api key and defaults' do
    SecureNative._flush
    api_key = 'API_KEY'
    securenative = SecureNative.init_with_api_key(api_key)
    options = securenative.options

    expect(options.api_key).to eq(api_key)
    expect(options.api_url).to eq('https://api.securenative.com/collector/api/v1')
    expect(options.interval).to eq(1000)
    expect(options.timeout).to eq(1500)
    expect(options.max_events).to eq(100)
    expect(options.auto_send).to eq(true)
    expect(options.disable).to eq(false)
    expect(options.log_level).to eq('FATAL')
    expect(options.fail_over_strategy).to eq(FailOverStrategy::FAIL_OPEN)
  end

  it 'inits sdk twice and throws' do
    expect { SecureNative.init_with_api_key('API_KEY') }.to raise_error(SecureNativeSDKException)
  end

  it 'inits sdk with api key and gets instance' do
    SecureNative._flush
    api_key = 'API_KEY'
    securenative = SecureNative.init_with_api_key(api_key)

    expect(securenative).to eq(SecureNative.instance)
  end

  it 'inits sdk with builder' do
    SecureNative._flush
    securenative = SecureNative.init_with_options(SecureNative.config_builder(api_key = 'API_KEY', max_events = 10, log_level = 'ERROR'))
    options = securenative.options

    expect(options.api_key).to eq('API_KEY')
    expect(options.max_events).to eq(10)
    expect(options.log_level).to eq('ERROR')
  end
end