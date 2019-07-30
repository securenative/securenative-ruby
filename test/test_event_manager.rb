require_relative '../lib/securenative/event_manager'
require_relative '../lib/securenative/securenative_options'
require_relative '../lib/securenative/event_type'
require_relative '../lib/securenative/event_options'
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

def build_event(type = EventType::LOG_IN, id)
  Event.new(event_type = type,
            user: User.new(user_id: id, user_email: 'support@securenative.com', user_name: 'support'),
            params: [CustomParam.new('key', 'val')]
  )
end

describe EventManager do
  let(:api_key) {ENV["SN_API_KEY"]}
  let(:event_manager) {EventManager.new(api_key, options: SecureNativeOptions.new, http_client: MockHttpClient.new)}

  it "post a synced request" do
    user_id = SecureRandom.uuid
    url = "https://postman-echo.com/post"
    event = build_event(EventType::LOG_IN, user_id)
    item = event_manager.send_async(event, url)
    event_manager.flush

    expect(item).to be_instance_of(Thread::Queue)
  end

  it "post an a-synced request" do
    user_id = SecureRandom.uuid
    url = "https://postman-echo.com/post"
    event = build_event(EventType::LOG_IN, user_id)

    res = event_manager.send_sync(event, url)
    expect(res).not_to be_empty
    expect(res[:data]).to eq(api_key)
    expect(res[:headers]["Content-Type"]).to eq("application/json")
    expect(res[:headers]["User-Agent"]).to eq("SecureNative-ruby")
    expect(res[:headers]["Sn-Version"]).to eq(Config::SDK_VERSION)
    expect(res[:headers]["Authorization"]).to eq(api_key)
  end
end
