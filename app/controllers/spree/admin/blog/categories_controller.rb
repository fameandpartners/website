class Spree::Admin::Blog::CategoriesController < Spree::Admin::BaseController

  def index
    @categories = Blog::Category.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    @blog_category = Blog::Category.new
  end

  def edit
    @blog_category = Blog::Category.find(params[:id])
  end

  def create
    attrs = params['blog_category']
    @blog_category = Blog::Category.new(attrs)
    @blog_category.user = current_spree_user
    if @blog_category.slug.blank? && @blog_category.name.present?
      @blog_category.slug = slug_from_name(@blog_category.name)
    end
    if @blog_category.valid?
      @blog_category.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def update
    attrs = params['blog_category']
    @blog_category = Blog::Category.find(params[:id])
    if @blog_category.update_attributes(attrs)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_category = Blog::Category.find(params[:id])
    @blog_category.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::Category
  end
end
