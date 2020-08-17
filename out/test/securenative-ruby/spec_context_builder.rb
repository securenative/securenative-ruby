# frozen_string_literal: true

require 'context/securenative_context'
require 'webmock/rspec'
require 'rspec'

RSpec.describe SecureNativeContext do
  it 'creates context from request' do
    stub_request(:any, 'www.example.com')
      .to_return(body: nil, status: 200,
                 headers: { 'x-securenative': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' },
                 remote_ip: '', uri: 'www.securenative.com', http_method: 'Post', ip: '51.68.201.122',
                 client_token: '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')

    request = Net::HTTP.get('www.example.com', '/')
    context = SecureNativeContext.from_http_request(request)

    expect(context.client_token).to eq('71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')
    expect(context.ip).to eq('51.68.201.122')
    expect(context.http_method).to eq('Post')
    expect(context.uri).to eq('www.securenative.com')
    expect(context.remote_ip).to eq('')
    expect(context.headers).to eq({ 'x-securenative': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' })
    expect(context.body).to be_nil
  end

  it 'creates context from request with cookie' do
    stub_request(:any, 'www.example.com')
      .to_return(body: nil, status: 200,
                 cookies: { '_sn': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' },
                 remote_ip: '', uri: 'www.securenative.com', http_method: 'Post', ip: '51.68.201.122',
                 client_token: '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')

    request = Net::HTTP.get('www.example.com', '/')
    con = SecureNativeContext.from_http_request(request)

    expect(con.context.client_token).to eq('71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')
    expect(con.context.ip).to eq('51.68.201.122')
    expect(con.context.http_method).to eq('Post')
    expect(con.context.uri).to eq('www.securenative.com')
    expect(con.context.remote_ip).to eq('')
    expect(con.context.body).to be_nil
  end

  it 'creates default context builder' do
    context = SecureNativeContext.default_context_builder

    expect(context.client_token).to be_nil
    expect(context.ip).to be_nil
    expect(context.http_method).to be_nil
    expect(context.url).to be_nil
    expect(context.remote_ip).to be_nil
    expect(context.headers).to be_nil
    expect(context.body).to be_nil
  end

  it 'creates custom context with context builder' do
    context = SecureNativeContext.new('SECRET_TOKEN', '10.0.0.0', '10.0.0.0',
                                      { 'header' => 'value1' }, '/some-url', 'Get', nil)

    expect(context.url).to eq('/some-url')
    expect(context.client_token).to eq('SECRET_TOKEN')
    expect(context.ip).to eq('10.0.0.0')
    expect(context.body).to be_nil
    expect(context.http_method).to eq('Get')
    expect(context.remote_ip).to eq('10.0.0.0')
    expect(context.headers).to eq({ 'header' => 'value1' })
  end
end
