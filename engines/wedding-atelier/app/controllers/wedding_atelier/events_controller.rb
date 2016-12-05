require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventsController < ApplicationController

    def index
      @events = current_spree_user.events
    end

    def show
      @event = Event.find_by_slug(params[:id])
      if @event.nil? || !@event.assistant_permitted?(current_spree_user)
        flash[:notice] = "You don't have permission to access this wedding board"
        redirect_to wedding_atelier.events_path
      end
    end
  end
end
