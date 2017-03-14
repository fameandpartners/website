require 'reform'

module Forms
  class CustomisationValueForm < ::Reform::Form
    property :name
    property :presentation
    property :price
    property :customisation_type
    property :point_of_view
    property :product_id
    property :image

    validates :name, presence: true
    validates :presentation, presence: true
    validates :customisation_type,  presence: true
    validates :product_id,  presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :point_of_view,
              presence: true,
              inclusion: CustomisationValue::AVAILABLE_POINTS_OF_VIEW,
              allow_nil: true,
              allow_blank: true

    def products
      Spree::Product.active
    end

    def customisation_types
      CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES
    end

    def points_of_view
      CustomisationValue::AVAILABLE_POINTS_OF_VIEW
    end
  end
end
