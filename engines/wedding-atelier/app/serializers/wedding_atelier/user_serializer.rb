module WeddingAtelier
  class UserSerializer < ActiveModel::Serializer

    has_one :user_profile
    attributes :first_name, :id, :name, :role, :joined_at, :email

    def name
      object.full_name
    end

    def joined_at
      object.created_at.strftime("%m/%d/%Y")
    end

    def role
      event = scope.instance_variable_get '@event'
      object.role_in_event(event) if event
    end
  end
end
