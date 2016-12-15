require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class EventDressesController < ApplicationController

    def new
    end

    def index
      @products = Spree::Taxon.find_by_permalink('base-silhouette').products
      render json: @products, each_serializer: WeddingAtelier::ProductSerializer
    end

    def edit
    end

    def create
      dress = event.dresses.create(
        user_id: spree_current_user.id,
        product_id: event_dress_params[:product_id]
      )
      render json: dress
    end

    def update
      dress = event.dresses.find(params[:id])
      if dress.update_attributes(event_dress_params)
        render json: dress
      else
        render json: { errors: dress.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      dress = event.dresses.find(params[:id])
      if dress.destroy
        render json: dress
      else
        render json: dress, status: :unprocessable_entity
      end
    end

    private

    def event
      @event ||= WeddingAtelier::Event.find_by_slug(params[:event_id])
    end

    def event_dress_params
      params[:event_dress]
    end

  end
end
