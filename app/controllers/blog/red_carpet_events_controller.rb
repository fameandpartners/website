class Blog::RedCarpetEventsController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def index
    @red_carpet_events = RedCarpetEvent.all
    @celebrity_photos = CelebrityPhoto.last(4)
  end

  def show
    @red_carpet_event = RedCarpetEvent.find_by_name! params[:id].gsub('_', ' ')
  end
end
