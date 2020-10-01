# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SecureNative::Utils::VersionUtils do
  it 'checks that parsing version is valid' do
    expect(SecureNative::Utils::VersionUtils.version).not_to eq('unknown')
  end
end
