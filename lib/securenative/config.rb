class Config
  def initialize
    @sdk_version = '0.1.5'
    @max_allowed_params = 6
    @api_url_prod = "https://api.securenative.com/collector/api/v1"
    @api_url_stg = "https://api.securenative-stg.com/collector/api/v1"
    @track_event = "/track"
    @verify_event = "/verify"
    @flow_event = "/flow"
  end

  attr_reader :sdk_version
  attr_reader :max_allowed_params
  attr_reader :api_url_prod
  attr_reader :api_url_stg
  attr_reader :track_event
  attr_reader :verify_event
  attr_reader :flow_event
end