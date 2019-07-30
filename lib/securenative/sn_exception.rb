class SecureNativeSDKException < StandardError
  def initialize(msg: "API key cannot be nil, please get your API key from SecureNative console")
    super
  end
end