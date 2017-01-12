module WeddingAtelier
  class AssistantsController < ApplicationController
    protect_from_forgery except: :destroy

    def destroy
      event_assistant = event.event_assistants.where(user_id: params[:id]).first
      if event_assistant && event_assistant.destroy
        render json: {status: :ok}
      else
        render json: {status: :fail}, status: :unprocessable_entity
      end
    end

    private
    def event
      spree_current_user.events.where(slug: params[:event_id]).first
    end
  end
end
