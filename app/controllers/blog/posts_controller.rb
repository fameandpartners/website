class Blog::PostsController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def index
    @celebrity_photos = CelebrityPhoto.last(4)
    @posts = PostState.find_by_title("Approved").posts.
                       where(category_id: Post::CATEGORIES[params[:category].to_s.titleize]).
                       order('id desc').
                       limit(1)

  end

  def show
    @post = Post.find(:first, :conditions => [ "lower(title) = ?", params[:id].gsub('_', ' ').downcase ])
  end
end
