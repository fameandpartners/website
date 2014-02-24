class CelebritiesController < ApplicationController
  layout 'spree/layouts/spree_application'

  def show
    @controller_action_id = 'products'
    @celebrity = Celebrity.find_by_slug(params[:id])

    @products = @celebrity.products
  end
end
