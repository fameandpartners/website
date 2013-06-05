class Blog::PostsController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def index
    @posts = Post.all
    @celebrity_photos = CelebrityPhoto.last(4)
  end

  def show
    @post = Post.find_by_title! params[:id].gsub('_', ' ')
  end
end
