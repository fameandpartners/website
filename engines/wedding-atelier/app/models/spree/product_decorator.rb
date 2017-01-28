Spree::Product.class_eval do
  def is_wedding_atelier_product?
    taxons.joins(:taxonomy).where('spree_taxonomies.name = ?', "Wedding Atelier").any?
  end
end
