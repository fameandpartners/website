class MoodboardItemsController < ApplicationController
  before_filter :authenticate_spree_user!

  def create
    moodboard_populator = UserMoodboard::Populator.new(
      user:       current_spree_user,
      product_id: params[:product_id],
      variant_id: params[:variant_id],
      color_id:   params[:color_id],
      moodboard:  moodboard
    )

    moodboard_populator.populate
  rescue StandardError => _e
      # TODO - Error Handling.
  ensure
    render json: user_moodboards
  end

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
