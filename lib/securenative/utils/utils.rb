class Utils
  def self.null_or_empty?(string)
    return true if !string.nil? && !string.empty?

    return true unless string.nil?

    false
  end
end