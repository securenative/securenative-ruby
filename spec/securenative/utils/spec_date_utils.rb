# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SecureNative::Utils::DateUtils do
  it 'converts to timestamp' do
    iso_8601_date = '2020-05-20T15:07:13Z'
    result = SecureNative::Utils::DateUtils.to_timestamp(iso_8601_date)

    expect(result).to eq(iso_8601_date)
  end
end
