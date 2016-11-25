module Spree
  module WeddingAtelier
    class EventsController < Spree::WeddingAtelier::BaseController

      def index
      end

      def show
        @event = Event.find_by_slug(params[:id])
      end
    end
  end
end
