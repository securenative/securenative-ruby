# frozen_string_literal: true

class DateUtils
  def self.to_timestamp(date)
    return Time.now.utc.iso8601 if date.nil?

    Time.parse(date).iso8601
  end
end
