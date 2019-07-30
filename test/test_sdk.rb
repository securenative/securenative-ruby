require_relative '../lib/securenative'
require_relative '../lib/securenative/securenative_options'
require_relative '../lib/securenative/event_type'
require_relative '../lib/securenative/event_options'
require 'rspec/autorun'
require 'securerandom'
require 'json'

def build_event(type = EventType::LOG_IN, id)
  Event.new(event_type = type,
            user: User.new(user_id: id, user_email: 'support@securenative.com', user_name: 'support'),
            params: [CustomParam.new('key', 'val')]
  )
end

describe SecureNative do
  let(:sn_options) {SecureNativeOptions.new}
  let(:sn_client) {SecureNative.new(ENV["SN_API_KEY"], options: sn_options)}

  it "use sdk without api key" do
    api_key = nil
    expect {SecureNative.new(api_key, options: sn_options)}.to raise_error(SecureNativeSDKException)
  end

  it "track an event" do
    user_id = SecureRandom.uuid
    event = build_event(EventType::LOG_IN, user_id)
    sn_client.track(event)
    expect(sn_client.flush).not_to be_empty
  end

  it "verify an event" do
    user_id = SecureRandom.uuid
    event = build_event(EventType::LOG_OUT, user_id)
    res = sn_client.verify(event)

    expect(res).not_to be_empty
    expect(res['triggers']).not_to be_empty
    expect(res['riskLevel']).to eq('high')
    expect(res['score']).to eq(0.64)
  end
end