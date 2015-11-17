class MoodboardsController < ApplicationController
  before_filter :authenticate_spree_user!

  respond_to :js, :html

  def index
    @collection = spree_current_user.moodboards
    @resource   = @collection.default_or_create

    render :show
  end

  def show
    @collection  = spree_current_user.moodboards
    candidate_id = params[:id].to_i
    @resource    = if candidate_id.nonzero?
                     @collection.find(candidate_id)
                   else
                     @collection.default_or_create
                   end
  end
end
