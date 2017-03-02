Spree::Product.class_eval do
  def from_wedding_atelier?
    taxons.map(&:permalink).include? 'base-silhouette'
  end
end
