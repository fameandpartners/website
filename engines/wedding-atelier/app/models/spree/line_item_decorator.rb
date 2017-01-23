Spree::LineItem.class_eval do
  scope :for_wedding_atelier, -> { joins(product: {taxons: :taxonomy}).where('spree_taxonomies.name = ?', 'Wedding Atelier') }
end
