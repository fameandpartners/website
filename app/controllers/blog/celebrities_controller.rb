class Blog::CelebritiesController < BlogBaseController
  def index
    @celebrities = Blog::Celebrity.all
  end

  def show
    @celebrity = Blog::Celebrity.find_by_slug!(params[:slug])
  end
end
