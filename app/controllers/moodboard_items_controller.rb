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

  # TODO - Wrap some logic and UI around this.
  def like_or_unlike
    if item.user_likes.split(",").include?(spree_current_user.id.to_s)
      item.events.unlike.create(user_id: spree_current_user.id)
    else
      item.events.like.create(user_id: spree_current_user.id)
    end
    render json: {likes: item.reload.likes}
  end

  def destroy
    item.events.removal.create(user_id: spree_current_user.id)
    redirect_to moodboard
  end

  helper_method def item
    candidate_id = params[:id].to_i
    @item ||= moodboard.items.find(candidate_id)
  end

  helper_method def moodboard
    candidate_id = params[:moodboard_id].to_i

    @moodboard ||= \
      spree_current_user.moodboards.where(id: candidate_id).first ||
      spree_current_user.shared_moodboards.where(id: candidate_id).first

    if @moodboard.present?
      @moodboard
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
