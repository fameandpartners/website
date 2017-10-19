require 'reform'

module Forms
  class SkuUpcForm < ::Reform::Form
    property :style_number
    property :style_name
    property :height
    property :color_name
    property :color_presentation_name
    property :sizes

    validates :style_number, :style_name, :height,
      :color_name, :color_presentation_name, :sizes, presence: true
  end
end
