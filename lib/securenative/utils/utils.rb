# frozen_string_literal: true

class Utils
  def self.null_or_empty?(string)
    return true if !string || string.empty? || string.nil?

    false
  end
end
