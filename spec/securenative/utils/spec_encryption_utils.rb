# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SecureNative::Utils::EncryptionUtils do
  it 'encrypts' do
    secret_key = 'AFD16D89150FD7FB19EE9E936DC1AE3547CE119B'
    payload = '{"cid":"198a41ff-a10f-4cda-a2f3-a9ca80c0703b","vi":"148a42ff-b40f-4cda-a2f3-a8ca80c0703b","fp":"6d8cabd95987f8318b1fe01593d5c2a5.24700f9f1986800ab4fcc880530dd0ed"}'
    result = SecureNative::Utils::EncryptionUtils.encrypt(payload, secret_key)

    expect(result).not_to be_nil
  end

  it 'decrypts' do
    secret_key = 'AFD16D89150FD7FB19EE9E936DC1AE3547CE119B'
    encrypted_payload = 'dfcc35bc71653771d4541f08937c35cbc98faea2c061ff7904f80abf7c072f0029157ed97a55b00efe09fb0d2f86f5693ecbba3f6339862ed3908f0d746533133c8c838be641dad76cf3f9cce67dc1b48cbc8574f24637be4aa90f802ec4b7e5d50b5f9cb3d64e6887ef99b8b941e69370ac7994ccafaf17ceff1d7a68ac30e4b0fe4eb1b844460d5f7687f16902cea61d0ccc085f7ea6087fae38482cd1ee1c7574dc4b0e996bc4e5946eeb8e8509fbdd9f1884eb3f02cbbaefe4566c999d50'
    cid = '12946065-65af-4825-9893-fce901c8da49'
    fp = '9a6e6a7d636ca772924bd2219853d73c.24700f9f1986800ab4fcc880530dd0ed'

    result = SecureNative::Utils::EncryptionUtils.decrypt(encrypted_payload, secret_key)

    expect(result.cid).to eq(cid)
    expect(result.fp).to eq(fp)
  end
end
