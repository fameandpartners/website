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
  def like
    item.events.like.create(user_id: spree_current_user.id)
    render json: {likes: item.reload.likes}
  end

  def unlike
    item.events.unlike.create(user_id: spree_current_user.id)
    render json: {'status' => 'ok'}
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
    @moodboard ||= begin
      spree_current_user.moodboards.where(id: candidate_id).first ||
        spree_current_user.shared_moodboards.where(id: candidate_id).first
    end
    raise ActiveRecord::RecordNotFound unless @moodboard.present?
    @moodboard
  end
end
