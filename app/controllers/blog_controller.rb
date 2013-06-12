class BlogController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def index
    @celebrity_photos = CelebrityPhoto.order("id desc").limit(4)
    @posts = {}
    %w{posts fashion_news style_tips prom_tips}.each do |category|
      @posts[category.to_sym] = PostState.find_by_title("Approved").posts.
                          where(category_id: Post::CATEGORIES[category.titleize]).
                          order('id desc').
                          limit(1).first
    end
    @posts[:red_carpet_events] = PostState.find_by_title("Approved").red_carpet_events.
                                   order('id desc').
                                   limit(1).first


  end
end
