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

  it "decrypt text" do
    cookie = "821cb59a6647f1edf597956243e564b00c120f8ac1674a153fbd707da0707fb236ea040d1665f3d294aa1943afbae1b26b2b795a127f883ec221c10c881a147bb8acb7e760cd6f04edc21c396ee1f6c9627d9bf1315c484a970ce8930c2ed1011af7e8569325c7edcdf70396f1abca8486eabec24567bf215d2e60382c40e5c42af075379dacdf959cb3fef74f9c9d15"
    decrypted = "12d6a631d6eb6a95a839f7c14a91d092209180e47eb715b98be38cfee65a69d514a6ec4b838674784473d608c9c28ab7b16ddf1866d098e54c9e9a62308a2a6b3277b33c9474ffad7fb7294bd612fcdab354d483e223972257915574f5d39869bbcf51e75fdd855f023877f207da8cbb3552f433f7e50f48826628993e5957eed80261d3d16dbf4f79db72484afbc28ed67c846ec0db4078cc9bfad19b0e89583c012a743ba17d59edb86d05edb29c7cc3ffdd21ef051f7347f30dc783579187bedbc053835943f52ba96e74e8ec1628f4e9aee6428f7174df8dc822e8ceddbf171fa3cad1215b4d313bbec63abec83f8c54b87a3f0ca25d525fa1522bf7d433553748cadcddb59cf82a572a6df819cf1402d2cb656a1dba2181f363b03dc4ec4d8d05feaff28ab9f9ce1b427962f1dda4b791946f5188e32aeeb97b1eb5681ce45a26a9a855f382e227614d8781740bf45cabf4d81e950cb97fa7565f187baa340eaadf495e87b767b2d1e185ecdbc915e32306deedc19bf899205e1a2b3aa62ee9fbfa5fa9482eefab95dd23d5c454c018809a5daac4ce4f7aa9278bb78fd184188ab2cd40aadaf5bdd7a47915787e63242c418da5e3c7547ce5819cf121fc3d571d3c7e48c882e73f5ac59f541753bf5c563fa9444d5212398b050a5029c2285c10658a80cdad96305c433d87e848f56b4b1d3b3ab4814bb4ac32fe21dd24684db3bc75a113822e85bfdeb68492dfcb301fba643741c7ff1e066938ebedef5dee90d049bbacb0b46870d2c"
    api_key = "6EA4915349C0AAC6F6572DA4F6B00C42DAD33E75"

    res = Utils.decrypt(cookie, api_key)
    expect(res).to_not be_empty
    expect(res).to eq(decrypted)
  end
end