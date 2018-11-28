class AddressSerializer < ActiveModel::Serializer
  attributes :address1, :address2, :city, :zipcode, :phone, :state, :country, :email, :firstname, :lastname
  self.root = false

  def state
    object.state_name
  end

  def country
    object.country.try(:name)
  end
end
