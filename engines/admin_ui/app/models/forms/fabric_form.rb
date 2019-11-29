require 'reform'

module Forms
  class FabricForm < ::Reform::Form
    property :name
    property :option_value_id
    property :option_fabric_color_value_id
    property :presentation
    property :material
    property :production_code
    collection :taxon_ids

    property :image

    validates :name, presence: true
    validates :presentation, presence: true
    validates :material, presence: true
    validates :production_code, presence: true
  end
end
