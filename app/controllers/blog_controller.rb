class BlogController < BlogBaseController
  def index
    @promo_banners        = Blog::PromoBanner.published.all
    @latest_photos        = Blog::CelebrityPhoto.includes(:celebrity, :post).latest
  end
end
