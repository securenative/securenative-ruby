# frozen_string_literal: true

require 'securenative'
require 'rspec'

RSpec.describe SignatureUtils do
  it 'verifies request payload' do
    signature = 'c4574c1748064735513697750c6223ff36b03ae3b85b160ce8788557d01e1d9d1c9cd942074323ee0061d3dcc8c94359c5acfa6eee8e2da095b3967b1a88ab73'
    payload = '{"id":"4a9157ffbd18cfbd73a57298","type":"security-action","flow":{"id":"62298c73a9bb433fbd1f75984a9157fd","name":"Block user that violates geo velocity"},"userId":"73a9bb433fbd1f75984a9157","userTraits":{"name":"John Doe","email":"john.doe@gmail.com"},"request":{"ip":"10.0.0.0","fp":"9bb433fb984a9157d1f7598"},"action":"block","properties":{"type":"customer"},"timestamp":"2020-02-23T22:28:55.387Z"}'
    secret_key = 'B00C42DAD33EAC6F6572DA756EA4915349C0A4F6'

    expect(SignatureUtils.valid_signature?(secret_key, payload, signature)).to be_truthy
  end

  it 'verifies request empty signature' do
    expect(SignatureUtils.valid_signature?('', '', 'B00C42DAD33EAC6F6572DA756EA4915349C0A4F6')).to be_falsey
  end
end
