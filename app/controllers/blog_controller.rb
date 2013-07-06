class BlogController < BlogBaseController
  def index
    @promo_banners        = Blog::PromoBanner.published.all
    @latest_photos        = Blog::CelebrityPhoto.latest
    generate_breadcrumbs
  end

  private

  def generate_breadcrumbs
    @breadcrumbs = [[root_path, 'Home']]
  end
end
