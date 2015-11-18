class MoodboardItemsController < ApplicationController
  before_filter :authenticate_spree_user!

  def show
  end

  def destroy
    item.events.removal.create(user_id: spree_current_user.id)
    redirect_to moodboard
  end

  helper_method def item
    candidate_id = params[:id].to_i
    @item ||= moodboard.items.find(candidate_id)
  end


  private def moodboard
    candidate_id = params[:moodboard_id].to_i
    spree_current_user.moodboards.find(candidate_id)
  end
end
