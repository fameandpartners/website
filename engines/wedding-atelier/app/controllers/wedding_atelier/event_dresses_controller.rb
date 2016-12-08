require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventDressesController < ApplicationController

    def new
    end

    def create
      dress = event.dresses.create(
        user_id: spree_current_user.id,
        product_id: params[:event_dress][:product_id]
      )
      render json: dress
    end

    def update
      dress = event.dresses.find(params[:id])
      dress.update_attributes(params[:event_dress])
      render json: dress
    end

    private

    def event
      @event ||= WeddingAtelier::Event.find_by_slug(params[:event_id])
    end

  end
end
