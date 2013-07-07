class Blog::CelebritiesController < BlogBaseController
  CELEBRITIES_PER_PAGE = 10

  def index
    @celebrities_count = Blog::Celebrity.count
    @celebrities = Blog::Celebrity.page(params[:page]).per(CELEBRITIES_PER_PAGE)

    respond_to do |format|
      format.js do
      end
      format.html do
        if current_spree_user.present?
          @photo_votes = Blog::CelebrityPhotoVote.where(
            user_id: current_spree_user.id, celebrity_photo_id: @celebrities.map(&:main_photo).reject(&:blank?).map(&:id)
          )
        end
        generate_breadcrumbs_for_index
      end
    end
  end

  def show
    @celebrity = Blog::Celebrity.find_by_slug!(params[:slug])
    if params[:type] == 'posts'
      @posts = @celebrity.posts.simple_posts
    end
    if current_spree_user.present?
      @photo_votes = Blog::CelebrityPhotoVote.where(
        user_id: current_spree_user.id, celebrity_photo_id: @celebrity.celebrity_photos.map(&:id)
      )
    end
    generate_breadcrumbs_for_show
  end

  def like
  end

  def dislike
  end

  private

  def generate_breadcrumbs_for_show
    @breadcrumbs = [[root_path, 'Home'], [blog_celebrity_path(@celebrity.slug), @celebrity.fullname]]
  end

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [blog_celebrities_path, 'All Celebrities']]
  end
end
