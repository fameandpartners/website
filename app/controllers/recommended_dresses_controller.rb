class RecommendedDressesController < ApplicationController
  layout 'spree/layouts/spree_application'

  def index
    @recommended_dresses = Spree::Product.active.featured
    ids = @recommended_dresses.map(&:id)
    @other_dresses = Spree::Product.active
    @other_dresses = @other_dresses.where(['spree_products.id NOT IN (?)', ids]) if ids.present?
    
    @colors = Products::ColorsSearcher.new(Spree::Product.active).retrieve_colors
  end
end
