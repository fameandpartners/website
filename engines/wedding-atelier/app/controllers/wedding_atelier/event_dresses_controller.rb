require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventDressesController < ApplicationController

    before_filter :find_event

    def new
    end

    def edit
      @dress = @event.dresses.find(params[:id])
    end

    def create
      dress = @event.dresses.build(event_dress_params)
      if dress.save
        render json: dress
      else
        render json: { errors: dress.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      dress = @event.dresses.find(params[:id])
      if dress.update_attributes(event_dress_params)
        render json: dress
      else
        render json: { errors: dress.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      dress = @event.dresses.find(params[:id])
      if dress.destroy
        render json: {status: :ok}
      else
        render json: dress, status: :unprocessable_entity
      end
    end

    private

    def find_event
      @event = WeddingAtelier::Event.find_by_slug(params[:event_id])
    end

    def event_dress_params
      params[:event_dress].merge(user_id: spree_current_user.id)
    end

  end
end
