class UserSerializer < ActiveModel::Serializer
    attributes :email, :is_admin, :first_name, :last_name, :id, :current_sign_in_at, :last_sign_in_at

    def is_admin
        object.admin?
    end
end