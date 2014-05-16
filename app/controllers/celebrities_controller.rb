class CelebritiesController < ApplicationController
  layout 'spree/layouts/spree_application'
  
  def index

  end

  def show
    @controller_action_id = 'products'
    @celebrity = Celebrity.find_by_slug(params[:id])

    @title = @celebrity.full_name + " Celebrity Style - " + default_seo_title
    @description = "25% off dresses inspired by " + @celebrity.full_name + ". " + ActionController::Base.helpers.strip_tags(@celebrity.body) + " " + default_meta_description

    @products = @celebrity.products
  end
end
