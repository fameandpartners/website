class BlogController < BlogBaseController
  def index
    title
    description

    #@promo_banners        = Blog::PromoBanner.published.all
    #@latest_photos        = Blog::CelebrityPhoto.latest
    #@featured_posts       = Blog::Post.featured
    #if current_spree_user.present?
    #  @photo_votes = Blog::CelebrityPhotoVote.where(
    #    user_id: current_spree_user.id, celebrity_photo_id: @latest_photos.map(&:id)
    #  )
    #end

    @featured_posts = Blog::Post.featured
    @latest_posts   = Blog::Post.limit(6)
  end

  private

  def generate_breadcrumbs
    @breadcrumbs = [[root_path, 'Home']]
  end
end
