class Blog::AuthorsController < BlogBaseController
  def index
    @authors = Blog::Author.all
    generate_breadcrumbs_for_index
  end

  private

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [blog_authors_path, 'Stylists']]
  end
end
