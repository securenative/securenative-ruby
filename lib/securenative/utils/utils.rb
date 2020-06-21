class Utils
  def self.is_null_or_empty(string)
    if !string.nil? && !string.empty?
      return true
    end
    unless string.nil?
      return true
    end
    return false
  end
end