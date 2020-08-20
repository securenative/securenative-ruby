# frozen_string_literal: true

class VersionUtils
  def self.version
    begin
      spec = Gem::Specification.load('securenative.gemspec')
      version = spec.version
    rescue StandardError
      version = 'unknown'
    end
    version
  end
end
