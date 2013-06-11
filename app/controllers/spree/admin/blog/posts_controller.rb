class Spree::Admin::Blog::PostsController < Spree::Admin::BaseController
  include PostHelper

  def index
    category = Category.find_by_title(params[:category].to_s.titleize)
    @posts = category ? category.posts : []
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new params[:post]
    @post.category = Category.find_by_title(params[:category].to_s.titleize)
    @post.user = spree_current_user
    if @post.save
      redirect_to admin_post_path(params[:category])
    else
      render :new
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    post = Post.find params[:id]
    if post.update_attributes(params[:post])
      redirect_to admin_post_path(params[:category])
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user == spree_current_user && spree_current_user.admin?
  end

  def publish
    post = Post.find params[:id]
    post.publish!
    redirect_to admin_blog_posts_path
  end

  def unpublish
    post = Post.find params[:id]
    post.unpublish!
    redirect_to admin_blog_posts_path
  end

end
