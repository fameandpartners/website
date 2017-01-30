require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class LikesController < ApplicationController
    def create
      like = event.dresses.find(params[:dress_id]).like_by(spree_current_user)
      if like.errors.blank?
        render json: like
      else
        render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      like = event.dresses.find(params[:dress_id]).dislike_by(spree_current_user)
      if like.errors.blank?
        render json: like
      else
        render json: like, status: :unprocessable_entity
      end
    end

    private
    def event
      @event ||= WeddingAtelier::Event.find_by_slug(params[:event_id])
    end
  end
end
