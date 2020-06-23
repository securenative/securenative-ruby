class Device
  attr_reader :device_id
  attr_writer :device_id

  def initialize(device_id)
    @device_id = device_id
  end
end