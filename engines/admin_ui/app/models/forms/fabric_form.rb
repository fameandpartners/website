require 'reform'

module Forms
  class FabricForm < ::Reform::Form
    property :name
    property :presentation
    property :material
    property :production_code
    property :taxon_ids, default: []

    property :image

    validates :name, presence: true
    validates :presentation, presence: true
    validates :material, presence: true
    validates :production_code, presence: true
  end
end
