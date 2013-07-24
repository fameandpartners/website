class RecommendedDressesController < ApplicationController
  before_filter :authenticate_spree_user!
  before_filter :check_style_profile_presence!

  layout 'spree/layouts/spree_application'

  def index
    @recommended_dresses = Spree::Product.recommended_for(current_spree_user)
    ids = @recommended_dresses.map(&:id)
    @other_dresses = Spree::Product.active
    @other_dresses = @other_dresses.where(['spree_products.id NOT IN (?)', ids]) if ids.present?
    @other_dresses = @other_dresses.uniq.sample(4)
    
    @colors = Products::ColorsSearcher.new(Spree::Product.active).retrieve_colors
  end

  private

  def check_style_profile_presence!
    unless current_spree_user.style_profile.present?
      raise CanCan::AccessDenied
    end
  end
end
