require 'rspec/autorun'
require "base64"
require_relative '../lib/securenative/utils'

describe Utils do
  it "verifies a signature" do
    secret = "super secretive secret"
    body = "random body"
    true_signature = "acfd06a839604c12d21649508c1b3fa25d84e043d2b1e26b5967b9f9883184227c80c249decd9229205c7d072d2c7dc0f5c525cf4c14209d34f72306de97d50c"
    false_signature = "c80c249decd9229205c7d072d2c7dc0f5c525cf4c14209d34f72306de97d50cacfd06a839604c12d21649508c1b3fa25d84e043d2b1e26b5967b9f9883184227"
    expect(Utils.verify_signature(secret, body, true_signature)).to eq(true)
    expect(Utils.verify_signature(secret, body, false_signature)).to eq(false)
  end

  it "successfully parse a cookie" do
    cookie = Utils.parse_cookie(Base64.encode64('{"fp": fp, "cid": cid}'))
    expect(cookie).to_not be_empty
    expect(cookie[0]).to eq("fp")
    expect(cookie[1]).to eq("cid")
  end

  it "fails at parsing a cookie" do
    cookie = Utils.parse_cookie
    expect(cookie).to_not be_empty
    expect(cookie[0]).to be_empty
    expect(cookie[1]).to be_empty
  end

  it "encrypt text" do
    plain_text = "Some random plain text for  test"
    key = "6EA4915349C0AAC6F6572DA4F6B00C42DAD33E75"
    encrypted = "B8D770D0F7388EC3DF62B0097C36C05CAB03E934F2E2760536004F87FE11644C"

    res = Utils.encrypt(plain_text, key)
    expect(res).to_not be_empty
    expect(res).to eq(encrypted)
  end

  it "decrypt text" do
    encrypted_text = "B8D770D0F7388EC3DF62B0097C36C05CAB03E934F2E2760536004F87FE11644C"
    decrypted = "Some random plain text for  test"
    key = "6EA4915349C0AAC6F6572DA4F6B00C42DAD33E75"

    res = Utils.decrypt(encrypted_text, key)
    expect(res).to_not be_empty
    expect(res).to eq(decrypted)
  end
end