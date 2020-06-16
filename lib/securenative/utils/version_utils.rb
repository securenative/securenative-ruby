class VersionUtils
  def self.get_version
    path = "VERSION"
    file = File.open(path)
    version = file.read
    file.close

    return version
  end
end