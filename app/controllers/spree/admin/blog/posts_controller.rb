class Spree::Admin::Blog::PostsController < Spree::Admin::BaseController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new params[:post]
    @post.user = spree_current_user
    if @post.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    post = Post.find params[:id]
    if post.update_attributes!(params[:post])
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user == spree_current_user && spree_current_user.admin?
  end
end
