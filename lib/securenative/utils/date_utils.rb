class DateUtils
  def self.to_timestamp(date)
    if date.nil?
      return Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
    end
    return Time.strptime(date, "%Y-%m-%dT%H:%M:%S.%L%Z")
  end
end