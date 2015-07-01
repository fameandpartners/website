module AdminUi
  module ReturnApprovals
    class EventsController < AdminUi::ApplicationController
      def index
        @events = ItemReturn.find(params[:item_return_id]).events
      end

      def new

        # binding.pry

        event_type = params[:event]

        if ItemReturnEvent.event_types.include?(event_type.to_s)
          # I would prefer to use public_send here, but it causes nomethod errors on Array
          @event = ItemReturn
                     .find(params[:item_return_id])
                     .events
                     .send(event_type)
                     .build
        end




      end
    end
  end
end
