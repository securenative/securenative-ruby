class DateUtils
  def self.to_timestamp(date)
    return Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%Z') if date.nil?

    Time.strptime(date, '%Y-%m-%dT%H:%M:%S.%L%Z')
  end
end