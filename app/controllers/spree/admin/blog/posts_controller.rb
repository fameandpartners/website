class Spree::Admin::Blog::PostsController < Spree::Admin::BaseController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create! params[:post]
    if @post.errors.any?
      render :new
    else
      redirect_to :index
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    post = Post.find params[:id]
    if post.update_attributes!(params[:post])
      redirect_to :index
    else
      render action: :edit
    end
  end
end
