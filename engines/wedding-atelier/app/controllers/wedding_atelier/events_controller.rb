require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventsController < ApplicationController
    protect_from_forgery except: :update

    def index
      @events = current_spree_user.events
    end

    def show
      @event = Event.find_by_slug(params[:id])
      if @event.nil? || !@event.assistant_permitted?(current_spree_user)
        flash[:notice] = "You don't have permission to access this wedding board"
        redirect_to wedding_atelier.events_path
      end
      respond_to do |format|
        format.html
        format.js { render json: {event: {dresses: [{name: 'Name'}]}} }
      end
    end

    def update
      @event = Event.find_by_slug(params[:id])
      if @event.update_attributes(params_event)
        render json: @event
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
