class Event < ActiveRecord::Base
  has_and_belongs_to_many :assistants, class_name: Spree.user_class.name
  resourcify :event_roles, role_cname: 'EventRole'

  attr_accessible :event_type,
                  :number_of_assistants,
                  :date
end
