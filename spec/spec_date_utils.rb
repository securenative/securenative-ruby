# frozen_string_literal: true

require 'securenative/utils/date_utils'
require 'rspec'

RSpec.describe SecureNative::DateUtils do
  it 'converts to timestamp' do
    iso_8601_date = '2020-05-20T15:07:13Z'
    result = SecureNative::DateUtils.to_timestamp(iso_8601_date)

    expect(result).to eq(iso_8601_date)
  end
end
