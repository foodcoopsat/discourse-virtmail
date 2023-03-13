class AddressSerializer < ApplicationSerializer

  attributes :id, :address, :domain, :localpart, :comment, :forward_only, :quota_bytes, :destinations, :allowed_users

  def address
    "#{localpart}@#{domain}"
  end

  def domain
    address_token[0]
  end

  def localpart
    address_token[1]
  end

  def comment
    value["comment"]
  end

  def forward_only
    value["forward_only"]
  end

  def quota_bytes
    value["quota_bytes"]
  end

  def destinations
    value["destinations"]
  end

  def allowed_users
    User.where(id: value["allowed_users"]).pluck(:username)
  end

  private

  def address_token
    @address_token ||= object.key.split("@")
  end

  def value
    @value ||= JSON.parse(object.value)
  end
end
