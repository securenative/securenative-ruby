require_relative '../lib/securenative/event_manager'
require_relative '../lib/securenative/securenative_options'
require_relative '../lib/securenative/event_builder'
require_relative '../lib/securenative/event_type'
require 'rspec/autorun'
require 'securerandom'

class MockHttpClient
  def post(path, data, _)
    {
        :path => path,
        :data => data,
        :headers => {
            "Content-Type" => 'application/json',
            "User-Agent" => 'SecureNative-ruby',
            "Sn-Version" => Config::SDK_VERSION,
            "Authorization" => data
        }
    }
  end
end

describe EventManager do
  let(:api_key) {ENV["SN_API_KEY"]}
  let(:event_manager) {EventManager.new(api_key, SecureNativeOptions.new, MockHttpClient.new)}
  let(:event_builder) {EventBuilder.new} #  TODO fix implementation

  it "post a synced request" do
    user_id = SecureRandom.uuid
    url = "https://postman-echo.com/post"
    event = event_builder.build(EventType::LOG_IN, user_id)

    expect(event_manager.send_async(event, url)).to be_instance_of(Thread::Queue)
  end

  it "post an asynced request" do
    user_id = SecureRandom.uuid
    url = "https://postman-echo.com/post"
    event = event_builder.build(EventType::LOG_IN, user_id)

    res = event_manager.send_sync(event, url)
    expect(res).not_to be_empty
    expect(res[:data]).to eq(api_key)
    expect(res[:headers]["Content-Type"]).to eq("application/json")
    expect(res[:headers]["User-Agent"]).to eq("SecureNative-ruby")
    expect(res[:headers]["Sn-Version"]).to eq(Config::SDK_VERSION)
    expect(res[:headers]["Authorization"]).to eq(api_key)
  end
end
