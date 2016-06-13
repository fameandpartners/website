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
    property :email, virtual: true
    property :first_name, virtual: true
    property :last_name, virtual: true
    property :address, virtual: true
    property :city, virtual: true
    property :state, virtual: true
    property :cntry, virtual: true
    property :zip, virtual: true
    property :phone, virtual: true

    def style_names
      Spree::Product.active
    end

  end
end
