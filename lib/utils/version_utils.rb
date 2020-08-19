# frozen_string_literal: true

class VersionUtils
  def self.version
    path = 'VERSION'
    file = File.open(path)
    version = file.read
    file.close

    version
  end
end
