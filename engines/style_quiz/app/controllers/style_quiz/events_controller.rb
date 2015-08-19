module StyleQuiz
  class EventsController < ::StyleQuiz::ApplicationController
    respond_to :json

    def create
      service = ::StyleQuiz::Events::EventBuilder.new(site_version: current_site_version, style_profile: style_profile)
      event = service.create(params[:event])

      render json: {
        id: event.id,
        name: event.name,
        date: event.date.strftime(service.date_format),
        event_type: event.event_type
      }, status: :ok
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
