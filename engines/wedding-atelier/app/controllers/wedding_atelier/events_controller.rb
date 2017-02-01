require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventsController < ApplicationController
    protect_from_forgery except: :update

    def index
      redirect_to event_path(current_spree_user.events.last)
    end

    def show
      @event = Event.find_by_slug(params[:id])
      @sizes = Spree::OptionType.size.option_values
      @heights = WeddingAtelier::Height.definitions

      if @event.nil? || !@event.assistant_permitted?(current_spree_user)
        flash[:notice] = "You don't have permission to access this wedding board"
        redirect_to wedding_atelier.events_path
      else
        respond_to do |format|
          format.html
          format.json { render json: @event, serializer: MoodboardEventSerializer }
        end
      end
    end

    def update
      @event = Event.find_by_slug(params[:id])
      if @event.update_attributes(params_event) && spree_current_user.update_role_in_event(params[:event][:role], @event)
        render json: @event, serializer: MoodboardEventSerializer
      else
        render json: {errors: @event.errors}, status: 422
      end
    end

    private
    def params_event
      params[:event].slice(:name, :date, :number_of_assistants)
    end
  end
end
