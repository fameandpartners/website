class BlogBaseController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html
  before_filter :load_categories
  before_filter :load_featured_celebrities

  private

  def current_ability
    @current_ability ||= Blog::Ability.new(try_spree_current_user)
  end

  def load_categories
    @categories = Blog::Category.all
  end

  def load_featured_celebrities
    @featured_celebrities = Blog::Celebrity.featured.order
  end

  def bread_crumbs
    []
  end
  helper_method :bread_crumbs
end
