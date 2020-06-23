class UserTraits
  attr_reader :name, :email, :created_at
  attr_writer :name, :email, :created_at

  def initialize(name = nil, email = nil, created_at = nil)
    @name = name
    @email = email
    @created_at = created_at
  end
end