require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class CustomizationsController < ApplicationController

    def index
      @event = spree_current_user.events.find_by_slug(params[:event_id])
      @customization = Customization.new(@event)
      render json: @customization
    end
  end
end
