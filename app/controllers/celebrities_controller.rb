class CelebritiesController < ApplicationController
  layout 'spree/layouts/spree_application'

  def index
    @controller_action_id = 'products'
    @celebrities = Celebrity.joins(:primary_image).where(is_published: true).order('first_name ASC, last_name ASC').limit(20)
  end

  def show
    @controller_action_id = 'products'
    @celebrity = Celebrity.find_by_slug(params[:id])
    @primary_image = @celebrity.primary_image
    @secondary_images = @celebrity.secondary_images
    @style_profile = @celebrity.style_profile
    @products = @celebrity.products
    @left_column, @right_column = @secondary_images.first(6).in_groups(2)
  end

  private

  def colors
    @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end
  helper_method :colors
end
