class Blog::AuthorsController < BlogBaseController
  def index
    @authors = Blog::Author.all
  end
end
