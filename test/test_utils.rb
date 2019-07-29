require 'rspec/autorun'
require_relative '../lib/securenative/utils'

describe Utils do
  it "verifies a signature" do
    secret = ""
    body = ""
    true_signature = ""
    false_signature = ""
    expect(Utils.verify_signature(secret, body, true_signature)).to eq(true)
    expect(Utils.verify_signature(secret, body, false_signature)).to eq(false)
  end

  it "successfully parse a cookie" do
  end

  it "fails at parsing a cookie" do
  end
end