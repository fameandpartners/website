require 'reform'

module Forms
  class RejectionForm < ::Reform::Form
    property :event_type, writeable: false
    property :user
    property :comment

    validates :user,    presence: true
    validates :comment, presence: true
  end
end
