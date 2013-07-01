class Blog::AuthorsController < BlogBaseController
  def index
    role = Spree::Role.moderator_role
    if role.present?
      @authors = role.users
    end
    generate_breadcrumbs_for_index
  end

  private

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [blog_authors_path, 'Stylists']]
  end
end
