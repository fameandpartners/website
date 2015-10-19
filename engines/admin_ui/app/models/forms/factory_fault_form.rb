require 'reform'

module Forms
  class FactoryFaultForm < ::Reform::Form
    property :user
    property :factory_fault

    validates :user, presence: true
  end
end
