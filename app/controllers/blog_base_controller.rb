class BlogBaseController < ApplicationController
  layout 'blog'
  respond_to :html
  before_filter :load_categories
  before_filter :load_featured_celebrities

  skip_before_filter :check_cart

  private

  def title(*args)
    super(t('page.blog.default.title'), args)
  end

  def description(*args)
    super(args, t('page.blog.default.description'))
    @description = Array.wrap(args).join(' | ')
  end

  #def current_ability
  #  @current_ability ||= Blog::Ability.new(try_spree_current_user)
  #end

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

  def blog_config
    @blog_config ||= Blog.config
  end
  helper_method :blog_config
end
