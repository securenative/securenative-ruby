class SampleEvent
  attr_reader :event_type, :timestamp, :rid, :user_id, :user_traits, :request, :properties

  def initialize
    @event_type = "custom-event"
    @timestamp = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
    @rid = "432532"
    @user_id = "1"
    @user_traits = UserTraits("some user", "email@securenative.com")
    @request = RequestContext()
    @properties = []
  end
end

describe EventManager do
  let(:event) { SampleEvent() }

  it "successfully sends sync event with status code 200" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_api_url("https://api.securenative-stg.com/collector/api/v1")

    res_body = "{\"data\": true}"
    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/some-path/to-api", json = json.loads(res_body), status = 200)
    event_manager = EventManager.new(options)
    data = event_manager.send_sync(self.event, "some-path/to-api", false)

    expect(res_body).to eq(data.text)
  end

  it "fails when send sync event status code is 401" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_api_url("https://api.securenative-stg.com/collector/api/v1")

    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/some-path/to-api", json = {}, status = 401)
    event_manager = EventManager.new(options)
    res = event_manager.send_sync(self.event, "some-path/to-api", false)

    expect(res.status_code).to eq(401)
  end

  it "fails when send sync event status code is 500" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_api_url("https://api.securenative-stg.com/collector/api/v1")

    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/some-path/to-api", json = {}, status = 500)
    event_manager = EventManager.new(options)
    res = event_manager.send_sync(self.event, "some-path/to-api", false)

    expect(res.status_code).to eq(500)
  end
end