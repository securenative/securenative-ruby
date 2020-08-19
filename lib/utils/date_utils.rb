# frozen_string_literal: true

class DateUtils
  def self.to_timestamp(date)
    return Time.now.strftime('%Y-%m-%dT%H:%M:%S%Z') if date.nil?

    Time.parse(date).iso8601
  end
end
