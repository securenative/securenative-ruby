# frozen_string_literal: true

class ConfigurationManager
  DEFAULT_CONFIG_FILE = 'securenative.yml'
  CUSTOM_CONFIG_FILE_ENV_NAME = 'SECURENATIVE_CONFIG_FILE'
  @config = nil

  def self.read_resource_file(resource_path)
    properties = {}
    begin
      @config = YAML.load_file(resource_path)
      properties = @config unless @config.nil?
    rescue StandardError => e
      SecureNative::Log.error("Could not parse securenative.config file #{resource_path}; #{e}")
    end
    properties
  end

  def self._get_resource_path(env_name)
    Env.fetch(env_name, ENV[DEFAULT_CONFIG_FILE])
  end

  def self.config_builder
    ConfigurationBuilder.new
  end

  def self._get_env_or_default(properties, key, default)
    return ENV[key] if ENV[key]
    return properties[key] if properties[key]

    default
  end

  def self.load_config
    options = ConfigurationBuilder.default_securenative_options

    resource_path = DEFAULT_CONFIG_FILE
    resource_path = ENV[CUSTOM_CONFIG_FILE_ENV_NAME] unless ENV[CUSTOM_CONFIG_FILE_ENV_NAME].nil?

    properties = read_resource_file(resource_path)

    ConfigurationBuilder.new(api_key: _get_env_or_default(properties, 'SECURENATIVE_API_KEY', options.api_key),
                             api_url: _get_env_or_default(properties, 'SECURENATIVE_API_URL', options.api_url),
                             interval: _get_env_or_default(properties, 'SECURENATIVE_INTERVAL', options.interval),
                             max_events: _get_env_or_default(properties, 'SECURENATIVE_MAX_EVENTS', options.max_events),
                             timeout: _get_env_or_default(properties, 'SECURENATIVE_TIMEOUT', options.timeout),
                             auto_send: _get_env_or_default(properties, 'SECURENATIVE_AUTO_SEND', options.auto_send),
                             disable: _get_env_or_default(properties, 'SECURENATIVE_DISABLE', options.disable),
                             log_level: _get_env_or_default(properties, 'SECURENATIVE_LOG_LEVEL', options.log_level),
                             fail_over_strategy: _get_env_or_default(properties, 'SECURENATIVE_FAILOVER_STRATEGY', options.fail_over_strategy),
                             proxy_headers: _get_env_or_default(properties, 'SECURENATIVE_PROXY_HEADERS', options.proxy_headers))
  end
end
