module WeddingAtelier
  class UserSerializer < ActiveModel::Serializer

    has_one :user_profile
    attributes :first_name, :id, :name, :role

    def name
      object.full_name
    end

    def role
      event = scope.instance_variable_get '@event'
      object.role_in_event(event) if event
    end

  end
end
