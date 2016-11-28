module Spree
  module WeddingAtelier
    class EventsController < Spree::WeddingAtelier::BaseController

      def index
      end

      def show
        @event = Event.find_by_slug(params[:id])
        if !@event.assistant_permitted?(current_spree_user)
          flash[:notice] = "You don't have permission to access this wedding board"
          redirect_to wedding_atelier_events_path
        end
      end
    end
  end
end
