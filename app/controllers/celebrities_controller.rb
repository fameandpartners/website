class CelebritiesController < ApplicationController
  layout 'spree/layouts/spree_application'

  def show
    @controller_action_id = 'products'
    @celebrity = Celebrity.find_by_slug(params[:id])
    @primary_image = @celebrity.primary_image
    @secondary_images = @celebrity.secondary_images
    @style_profile = @celebrity.style_profile
    @products = @celebrity.products.active
    @left_column, @right_column = @secondary_images.first(6).in_groups(2)
  end

  private

  def colors
    @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end
  helper_method :colors
end
