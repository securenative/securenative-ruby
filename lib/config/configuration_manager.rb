require 'parseconfig'

class ConfigurationManager
  DEFAULT_CONFIG_FILE = "securenative.cfg"
  CUSTOM_CONFIG_FILE_ENV_NAME = "SECURENATIVE_COMFIG_FILE"
  @config = nil

  def self.read_resource_file(resource_path)
    @config = ParseConfig.new(resource_path)

    properties = {}
    @config.get_groups.each { |group|
      group.each do |key, value|
        properties[key.upcase] = value
      end
    }
    return properties
  end

  def self._get_resource_path(env_name)
    return Env.fetch(env_name, ENV[DEFAULT_CONFIG_FILE])
  end

  def self.config_builder
    return ConfigurationBuilder.default_config_builder
  end

  def self._get_env_or_default(properties, key, default)
    if Env[key]
      return Env[key]
    end

    if properties[key]
      return properties[key]
    end
    return default
  end

  def self.load_config
    options = ConfigurationBuilder().default_securenative_options

    resource_path = DEFAULT_CONFIG_FILE
    if Env[CUSTOM_CONFIG_FILE_ENV_NAME]
      resource_path = Env[CUSTOM_CONFIG_FILE_ENV_NAME]
    end

    properties = read_resource_file(resource_path)

    return ConfigurationBuilder()
               .with_api_key(_get_env_or_default(properties, "SECURENATIVE_API_KEY", options.api_key))
               .with_api_url(_get_env_or_default(properties, "SECURENATIVE_API_URL", options.api_url))
               .with_interval(_get_env_or_default(properties, "SECURENATIVE_INTERVAL", options.interval))
               .with_max_events(_get_env_or_default(properties, "SECURENATIVE_MAX_EVENTS", options.max_events))
               .with_timeout(_get_env_or_default(properties, "SECURENATIVE_TIMEOUT", options.timeout))
               .with_auto_send(_get_env_or_default(properties, "SECURENATIVE_AUTO_SEND", options.auto_send))
               .with_disable(_get_env_or_default(properties, "SECURENATIVE_DISABLE", options.disable))
               .with_log_level(_get_env_or_default(properties, "SECURENATIVE_LOG_LEVEL", options.log_level))
               .with_fail_over_strategy(_get_env_or_default(properties, "SECURENATIVE_FAILOVER_STRATEGY", options.fail_over_strategy))
  end
end