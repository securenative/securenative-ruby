# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe VersionUtils do
  it 'checks that parsing version is valid' do
    expect(VersionUtils.version).not_to eq('unknown')
  end
end
