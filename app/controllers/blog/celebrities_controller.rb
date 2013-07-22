class Blog::CelebritiesController < BlogBaseController
  CELEBRITIES_PER_PAGE = 10

  def index
    title 'Celebrities'
    description 'Follow celebrities fashion styles.'

    @celebrities_count = Blog::Celebrity.count
    @celebrities = Blog::Celebrity.includes(:primary_photo).page(params[:page]).per(CELEBRITIES_PER_PAGE)

    respond_to do |format|
      format.js do
      end
      format.html do
        if current_spree_user.present?
          @photo_votes = Blog::CelebrityPhotoVote.where(
            user_id: current_spree_user.id, celebrity_photo_id: @celebrities.map(&:primary_photo).reject(&:blank?).map(&:id)
          )
        end
        generate_breadcrumbs_for_index
      end
    end
  end

  def show
    @celebrity = Blog::Celebrity.find_by_slug!(params[:slug])

    title @celebrity.full_name
    description "Follow #{@celebrity.full_name}'s fashion style."

    if params[:type] == 'posts'
      @posts = @celebrity.posts.red_carpet_posts
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
