# frozen_string_literal: true

require 'context/securenative_context'
require 'webmock/rspec'
require 'rails'
require 'hanami'
require 'sinatra'
require 'rspec'

RSpec.describe SecureNativeContext do
  it 'creates context from ruby default request' do
    stub_request(:any, 'www.example.com')
        .to_return(status: 200,
                   headers: { '_sn': '71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a' })

    request = Net::HTTP.get_response('www.example.com', '/')
    context = SecureNativeContext.from_http_request(request)

    expect(context.ip).to eq('')
    expect(context.http_method).to eq('')
    expect(context.url).to eq('')
    expect(context.remote_ip).to eq('')
    expect(context.headers['-sn']).to eq(['71532c1fad2c7f56118f7969e401f3cf080239140d208e7934e6a530818c37e544a0c2330a487bcc6fe4f662a57f265a3ed9f37871e80529128a5e4f2ca02db0fb975ded401398f698f19bb0cafd68a239c6caff99f6f105286ab695eaf3477365bdef524f5d70d9be1d1d474506b433aed05d7ed9a435eeca357de57817b37c638b6bb417ffb101eaf856987615a77a'])
    expect(context.body).to eq('')
  end

  it 'creates context from rails request' do
    request = ActionDispatch::Request.new(nil)
    context = SecureNativeContext.from_http_request(request)

    expect(context.ip).to eq('')
    expect(context.http_method).to eq('')
    expect(context.url).to eq('')
    expect(context.remote_ip).to eq('')
    expect(context.headers).to eq([])
    expect(context.body).to eq('')
  end

  it 'creates context from sinatra request' do
    request = Sinatra::Request.new(nil)
    context = SecureNativeContext.from_http_request(request)

    expect(context.ip).to eq('')
    expect(context.http_method).to eq('')
    expect(context.url).to eq('')
    expect(context.remote_ip).to eq('')
    expect(context.headers).to eq([])
    expect(context.body).to eq('')
  end

  it 'creates context from hanami request' do
    request = Hanami::Action::Request
    context = SecureNativeContext.from_http_request(request)

    expect(context.ip).to eq('')
    expect(context.http_method).to eq('')
    expect(context.url).to eq('')
    expect(context.remote_ip).to eq('')
    expect(context.headers).to eq([])
    expect(context.body).to eq('')
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
    context = SecureNativeContext.new(client_token: 'SECRET_TOKEN', ip: '10.0.0.0', remote_ip: '10.0.0.0',
                                      headers: { 'header' => 'value1' }, url: '/some-url', http_method: 'Get', body: nil)

    expect(context.url).to eq('/some-url')
    expect(context.client_token).to eq('SECRET_TOKEN')
    expect(context.ip).to eq('10.0.0.0')
    expect(context.body).to be_nil
    expect(context.http_method).to eq('Get')
    expect(context.remote_ip).to eq('10.0.0.0')
    expect(context.headers).to eq({ 'header' => 'value1' })
  end
end
