require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AssistantsController < ApplicationController
    def destroy
      event = WeddingAtelier::Event.find(params[:event_id])
      event_assistant = event.event_assistants.where(user_id: params[:id]).first
      if event_assistant
        event_assistant.destroy
        render json: event_assistant
      else
        render json: { errors: "Couldn't find board member" }, status: :not_found
      end
    end
  end
end
