class UserTraits
  attr_reader :name, :email, :phone, :created_at
  attr_writer :name, :email, :phone, :created_at

  def initialize(name = nil, email = nil, phone = nil, created_at = nil)
    @name = name
    @email = email
    @created_at = created_at
    @phone = phone
  end
end