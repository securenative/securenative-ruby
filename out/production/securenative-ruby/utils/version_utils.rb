# frozen_string_literal: true

class VersionUtils
  def self.version
    begin
      Gem.loaded_specs['securenative'].version.to_s
    rescue StandardError
      'unknown'
    end
  end
end
