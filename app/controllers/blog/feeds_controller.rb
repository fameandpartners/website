class Blog::FeedsController < BlogBaseController
  respond_to :rss

  def index
    @posts = Blog::Post.published
  end
end
