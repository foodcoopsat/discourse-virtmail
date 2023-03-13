class AuthorizeAddressSerializer < ApplicationSerializer
  attributes :address, :comment

  def address
    object.key.split("@").reverse.join("@")
  end

  def comment
    JSON.parse(object.value)["comment"]
  end
end
