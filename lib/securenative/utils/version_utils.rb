# frozen_string_literal: true

module SecureNative
  module Utils
    class VersionUtils
      def self.version
        begin
          Gem.loaded_specs['securenative'].version.to_s
        rescue StandardError
          'unknown'
        end
      end
    end
  end
end