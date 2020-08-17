# frozen_string_literal: true

require 'parseconfig'

class ConfigurationManager
  DEFAULT_CONFIG_FILE = 'securenative.cfg'
  CUSTOM_CONFIG_FILE_ENV_NAME = 'SECURENATIVE_COMFIG_FILE'
  @config = nil

  def self.read_resource_file(resource_path)
    @config = ParseConfig.new(resource_path)

    properties = {}
    @config.get_groups.each { |group|
      group.each do |key, value|
        properties[key.upcase] = value
      end
    }
    properties
  end

  def self._get_resource_path(env_name)
    Env.fetch(env_name, ENV[DEFAULT_CONFIG_FILE])
  end

  def self.config_builder
    ConfigurationBuilder.default_config_builder
  end

  def self._get_env_or_default(properties, key, default)
    return Env[key] if Env[key]
    return properties[key] if properties[key]

    default
  end

  def self.load_config
    options = ConfigurationBuilder().default_securenative_options

    resource_path = DEFAULT_CONFIG_FILE
    resource_path = Env[CUSTOM_CONFIG_FILE_ENV_NAME] if Env[CUSTOM_CONFIG_FILE_ENV_NAME]

    properties = read_resource_file(resource_path)

    ConfigurationBuilder(_get_env_or_default(properties, 'SECURENATIVE_API_KEY', options.api_key),
                         _get_env_or_default(properties, 'SECURENATIVE_API_URL', options.api_url),
                         _get_env_or_default(properties, 'SECURENATIVE_INTERVAL', options.interval),
                         _get_env_or_default(properties, 'SECURENATIVE_MAX_EVENTS', options.max_events),
                         _get_env_or_default(properties, 'SECURENATIVE_TIMEOUT', options.timeout),
                         _get_env_or_default(properties, 'SECURENATIVE_AUTO_SEND', options.auto_send),
                         _get_env_or_default(properties, 'SECURENATIVE_DISABLE', options.disable),
                         _get_env_or_default(properties, 'SECURENATIVE_LOG_LEVEL', options.log_level),
                         _get_env_or_default(properties, 'SECURENATIVE_FAILOVER_STRATEGY', options.fail_over_strategy))
  end
end
