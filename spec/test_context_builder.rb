describe ContextBuilder do
  it 'creates context from request' do
    # TODO: code here
  end

  it 'creates context from request with cookie' do
    # TODO: code here
  end

  it 'creates default context builder' do
    context = ContextBuilder.default_context_builder.build

    expect(context.client_token).not_to be_empty
    expect(context.ip).not_to be_empty
    expect(context.method).not_to be_empty
    expect(context.url).not_to be_empty
    expect(context.remote_ip).not_to be_empty
    expect(context.headers).not_to be_empty
    expect(context.body).not_to be_empty
  end

  it 'creates custom context with context builder' do
    context = ContextBuilder.default_context_builder.with_url('/some-url').with_client_token('SECRET_TOKEN').with_ip('10.0.0.0').with_body('{ "name": "YOUR_NAME" }').with_method('Get').with_remote_ip('10.0.0.1').with_headers({ header1: 'value1' }).build

    expect(context.url).to eq('/some-url')
    expect(context.client_token).to eq('SECRET_TOKEN')
    expect(context.ip).to eq('10.0.0.0')
    expect(context.body).to eq('{ "name": "YOUR_NAME" }')
    expect(context.method).to eq('Get')
    expect(context.remote_ip).to eq('10.0.0.0')
    expect(context.headers).to eq({ header1: 'value1' })
  end
end