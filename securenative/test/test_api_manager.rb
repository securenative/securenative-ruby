describe ApiManager do
  let(:context) { ContextBuilder().with_ip("127.0.0.1").with_client_token("SECURED_CLIENT_TOKEN").with_headers({"user-agent" => "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405"}).build }
  let(:event_options) { EventOptionsBuilder(EventTypes.LOG_IN).with_user_id("USER_ID").with_user_traits(UserTraits("USER_NAME", "USER_EMAIL")).with_context(context).with_properties({:prop1 => "CUSTOM_PARAM_VALUE", :prop2 => true, :prop3 => 3}).build }

  it "tracks an event" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_auto_send(true).with_interval(10).with_api_url("https://api.securenative-stg.com/collector/api/v1")

    expected = "{\"eventType\":\"sn.user.login\",\"userId\":\"USER_ID\",\"userTraits\":{" \
                   "\"name\":\"USER_NAME\",\"email\":\"USER_EMAIL\",\"createdAt\":null},\"request\":{" \
                   "\"cid\":null,\"vid\":null,\"fp\":null,\"ip\":\"127.0.0.1\",\"remoteIp\":null,\"headers\":{" \
                   "\"user-agent\":\"Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) " \
                   "AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405\"},\"url\":null,\"method\":null}," \
                   "\"properties\":{\"prop2\":true,\"prop1\":\"CUSTOM_PARAM_VALUE\",\"prop3\":3}}"

    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/track", json = json.loads(expected), status = 200)
    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)

    begin
      api_manager.track(event_options)
    ensure
      event_manager.stop_event_persist
    end
  end

  it "uses invalid options" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_auto_send(true).with_interval(10).with_api_url("https://api.securenative-stg.com/collector/api/v1")

    properties = {}
    (0..12).each { |i|
      properties[i] = i
    }

    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/track", json = {}, status = 200)
    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)

    begin
      expect { api_manager.track(EventOptionsBuilder(EventTypes.LOG_IN).with_properties(properties).build) }.to raise_error(Errors::SecureNativeInvalidOptionsException)
    ensure
      event_manager.stop_event_persist
    end
  end

  it "verifies an event" do
    options = ConfigurationManager.config_builder.with_api_key("YOUR_API_KEY").with_api_url("https://api.securenative-stg.com/collector/api/v1")

    # TODO
    responses.add(responses.POST, "https://api.securenative-stg.com/collector/api/v1/verify", json = {:riskLevel => "medium", :score => 0.32, :triggers => ["New IP", "New City"]}, status = 200)
    verify_result = VerifyResult.new(RiskLevel.LOW, 0, nil)

    event_manager = EventManager.new(options)
    event_manager.start_event_persist
    api_manager = ApiManager.new(event_manager, options)

    result = api_manager.verify(event_options)

    expect(result).not_to be_empty
    expect(result.risk_level).to eq(verify_result.risk_level)
    expect(result.score).to eq(verify_result.score)
    expect(result.triggers).to eq(verify_result.triggers)
  end
end