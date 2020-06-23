# frozen_string_literal: true

require 'webmock/rspec'

describe ContextBuilder do
  it 'creates context from request' do
    stub_request(:any, 'www.example.com')
      .to_return(body: nil, status: 200,
                 headers: { 'x-securenative': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' },
                 remote_ip: '', uri: 'www.securenative.com', method: 'Post', ip: '51.68.201.122',
                 client_token: '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')

    request = Net::HTTP.get('www.example.com', '/')
    context = ContextBuilder.from_http_request(request)

    expect(context.client_token).to eq('71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')
    expect(context.ip).to eq('51.68.201.122')
    expect(context.method).to eq('Post')
    expect(context.uri).to eq('www.securenative.com')
    expect(context.remote_ip).to eq('')
    expect(context.headers).to eq({ 'x-securenative': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' })
    expect(context.body).to be_nil
  end

  it 'creates context from request with cookie' do
    stub_request(:any, 'www.example.com')
      .to_return(body: nil, status: 200,
                 cookies: { '_sn': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' },
                 remote_ip: '', uri: 'www.securenative.com', method: 'Post', ip: '51.68.201.122',
                 client_token: '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')

    request = Net::HTTP.get('www.example.com', '/')
    context = ContextBuilder.from_http_request(request)

    expect(context.client_token).to eq('71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a')
    expect(context.ip).to eq('51.68.201.122')
    expect(context.method).to eq('Post')
    expect(context.uri).to eq('www.securenative.com')
    expect(context.remote_ip).to eq('')
    expect(context.body).to be_nil
  end

  it 'creates default context builder' do
    context = ContextBuilder.default_context_builder.build

    expect(context.client_token).not_to be_nil
    expect(context.ip).not_to be_nil
    expect(context.method).not_to be_nil
    expect(context.url).not_to be_nil
    expect(context.remote_ip).not_to be_nil
    expect(context.headers).not_to be_nil
    expect(context.body).not_to be_nil
  end

  it 'creates custom context with context builder' do
    context = ContextBuilder(url = '/some-url', client_token = 'SECRET_TOKEN', ip = '10.0.0.0', body = '{ "name": "YOUR_NAME" }', method = 'Get', remote_ip = '10.0.0.1', headers = { header1: 'value1' })

    expect(context.url).to eq('/some-url')
    expect(context.client_token).to eq('SECRET_TOKEN')
    expect(context.ip).to eq('10.0.0.0')
    expect(context.body).to eq('{ "name": "YOUR_NAME" }')
    expect(context.method).to eq('Get')
    expect(context.remote_ip).to eq('10.0.0.0')
    expect(context.headers).to eq({ header1: 'value1' })
  end
end