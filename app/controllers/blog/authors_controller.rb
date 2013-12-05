class Blog::AuthorsController < BlogBaseController
  AUTHORS_PER_PAGE=10

  def index
    title 'Our stylists'
    description 'Our stylists'

    role = Spree::Role.moderator_role
    @authors_count = role.users.count
    if role.present?
      @authors = role.users.page(params[:page]).per(AUTHORS_PER_PAGE)
    end
    respond_to do |format|
      format.js do
      end
      format.html do
        generate_breadcrumbs_for_index
      end
    end
  end

  def show
    @author = Spree::User.find_by_slug!(params[:stylist])
    @posts  = @author.posts.published.includes(:category, :user, :post_photos)
    generate_breadcrumbs_for_show

    title "Our stylist #{@author.full_name}"
    description "Our stylist #{@author.full_name}"
  end

  private

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[blog_path, 'Home'], [blog_authors_path, 'Stylists']]
  end

  def generate_breadcrumbs_for_show
    @breadcrumbs = [[blog_path, 'Home'], [blog_authors_path, 'Stylists'], [blog_authors_post_path, @author.fullname]]
  end
end
