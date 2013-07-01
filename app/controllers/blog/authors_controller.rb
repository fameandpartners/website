class Blog::AuthorsController < BlogBaseController
  def index
    role = Spree::Role.moderator_role
    if role.present?
      @authors = role.users
    end
    generate_breadcrumbs_for_index
  end

  def show
    @author = Spree::User.find_by_slug!(params[:stylist])
    @posts  = @author.posts.published.includes(:category, :user, :post_photos)
    generate_breadcrumbs_for_show
  end

  private

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [blog_authors_path, 'Stylists']]
  end

  def generate_breadcrumbs_for_show
    @breadcrumbs = [[root_path, 'Home'], [blog_authors_path, 'Stylists'], [blog_authors_post_path, @author.fullname]]
  end
end
