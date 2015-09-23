require 'reform'

module Forms
  class ReceiveItemForm < ::Reform::Form
    property :user
    property :location
    property :received_on
    property :event_type, writeable: false

    def received_on
      super || Date.today
    end

    validates :user, presence: true
    validates :location, presence: true
    validates :received_on, presence: true
  end
end
