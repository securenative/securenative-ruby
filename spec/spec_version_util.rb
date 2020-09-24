# frozen_string_literal: true

require 'securenative/utils/version_utils'
require 'rspec'

RSpec.describe SecureNative::VersionUtils do
  it 'checks that parsing version is valid' do
    expect(SecureNative::VersionUtils.version).not_to eq('unknown')
  end
end
