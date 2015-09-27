require 'reform'

module Forms
  class ApproveForm < ::Reform::Form
    property :event_type, writeable: false
    property :user
    property :comment

    validates :user, presence: true
  end
end
