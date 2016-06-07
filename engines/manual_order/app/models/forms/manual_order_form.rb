require 'reform'

module Forms
  class ManualOrderForm < ::Reform::Form

    property :style_name, virtual: true
    property :size, virtual: true
    property :length, virtual: true
    property :color, virtual: true
    property :customisations, virtual: true
    property :notes, virtual: true
    property :status, virtual: true

    def style_names
      Spree::Product.active
    end

  end
end
