class Blog::CelebritiesController < BlogBaseController
  def index
    @celebrities = Blog::Celebrity.all
    generate_breadcrumbs_for_index
  end

  def show
    @celebrity = Blog::Celebrity.find_by_slug!(params[:slug])
    generate_breadcrumbs_for_show
  end

  private

  def generate_breadcrumbs_for_show
    @breadcrumbs = [[root_path, 'Home'], [blog_celebrity_path(@celebrity.slug), @celebrity.fullname]]
  end

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [blog_celebrities_path, 'All Celebrities']]
  end
end
