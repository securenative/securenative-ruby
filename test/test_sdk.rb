require_relative '../lib/securenative'
require_relative '../lib/securenative/securenative_options'
require_relative '../lib/securenative/event_builder'
require_relative '../lib/securenative/event_type'
require 'rspec/autorun'
require 'securerandom'
require 'json'

describe SecureNative do
  let(:sn_options) {SecureNativeOptions.new}
  let(:sn_client) {SecureNative.new(ENV["SN_API_KEY"], sn_options)}
  let(:event_builder) {EventBuilder.new}  #  TODO fix implementation

  it "use sdk without api key" do
    api_key = nil
    expect {SecureNative.new(api_key, sn_options)}.to raise_error(SecureNativeSDKException)
  end

  it "track an event" do
    user_id = SecureRandom.uuid
    event = event_builder.build(EventType::LOG_IN, user_id)
    expect(sn_client.track(event)).not_to be_empty
  end

  it "verify an event" do
    user_id = SecureRandom.uuid
    event = event_builder.build(EventType::LOG_OUT, user_id)
    res = sn_client.verify(event)

    expect(res).not_to be_empty
    expect(res['triggers']).not_to be_empty
    expect(res['riskLevel']).to eq('high')
    expect(res['score']).to eq(0.64)
  end
end