class UserSerializer < ActiveModel::Serializer
    attributes :email, :is_admin, :first_name, :last_name, :id

    def is_admin
        object.admin?
    end
end