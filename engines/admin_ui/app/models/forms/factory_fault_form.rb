require 'reform'

module Forms
  class FactoryFaultForm < ::Reform::Form
    property :user
    property :factory_fault
    property :factory_fault_reason

    validates :user, presence: true
  end
end
