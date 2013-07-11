class Spree::Admin::Blog::PromoBannersController < Spree::Admin::Blog::BaseController

  def index
    scope = Blog::PromoBanner.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
    @blog_promo_banners = scope.order('position asc')
  end

  def new
    @blog_promo_banner = Blog::PromoBanner.new
  end

  def edit
    @blog_promo_banner = Blog::PromoBanner.find(params[:id])
  end

  def create
    attrs = params['blog_promo_banner']
    @blog_promo_banner = Blog::PromoBanner.new(attrs)
    @blog_promo_banner.user = current_spree_user
    if @blog_promo_banner.valid?
      @blog_promo_banner.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    attrs = params['blog_promo_banner']
    @blog_promo_banner = Blog::PromoBanner.find(params[:id])
    @blog_promo_banner.assign_attributes(attrs)
    if @blog_promo_banner.valid?
      if attrs['published'] == '1'
        @blog_promo_banner.published = true
      else
        @blog_promo_banner.published = false
      end
      @blog_promo_banner.save
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_promo_banner = Blog::PromoBanner.find(params[:id])
    @blog_promo_banner.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::PromoBanner
  end
end
