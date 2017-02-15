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

    validates :presentation, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :point_of_view, inclusion: %w(front back), allow_nil: true, allow_blank: true
    validates_uniqueness_of :presentation
    validates_uniqueness_of :name
  end
end
