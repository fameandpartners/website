module StyleQuiz
  class EventsController < ::StyleQuiz::ApplicationController
    respond_to :json

    def create
      event = style_profile.events.new(params[:event])

      if event.save
        render json: { 
          id: event.id,
          name: event.name,
          date: event.date.to_s(:db),
          event_type: event.event_type
        }, status: :ok
      else
        render json: {}, status: :error
      end
    rescue
      render json: {}, status: :error
    end

    def destroy
      style_profile.events.where(id: params[:id]).destroy_all

      render json: {}, status: :ok
    end

    private

      def style_profile
        @style_profile ||= current_spree_user.style_profile
      end
  end
end
