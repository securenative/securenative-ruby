# frozen_string_literal: true

module SecureNative
  class Utils
    def self.null_or_empty?(string)
      return true if !string || string.empty? || string.nil?

      false
    end
  end
end
