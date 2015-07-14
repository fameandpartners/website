module AdminUi
  module ReturnApprovals
    class EventsController < AdminUi::ApplicationController

      respond_to :html

      helper_method :event_type

      def page_title
        return super unless event_type.present?
        event_type.to_s.titleize
      end

      def index
        @events = item_return.events
      end

      def new
        if event_type && event_type == :receive_item
          @event = event_for(item_return_id: params[:item_return_id])
          @form  = ::Forms::ReceiveItemForm.new(@event)

          use_layout = request.xhr? ? 'modal_content' : _layout

          respond_with(@form) do |format|
            format.html { render :layout => use_layout }
          end
        else
          redirect_to item_return, alert: "No Event Type #{event_type}"
        end
      end

      def create
        form_data = { user: current_admin_user.email }.merge(params[:event_data])

        if event_type
          @event = event_for(item_return_id: params[:item_return_id])

          @form = ::Forms::ReceiveItemForm.new(@event)
          if @form.validate(form_data)
            @form.save
            redirect_to @event.item_return
          end
        else
          redirect_to item_return, alert: "No Event Type #{event_type}"
        end
      end

      private

      def event_type
        if ItemReturnEvent.event_types.include?(event_type = params[:event_type])
          event_type.to_sym
        end
      end

      def event_for(item_return_id:)
        # I would prefer to use public_send here, but it causes NoMethodErrors on Array instead of getting the event. :wat:
        item_return(item_return_id: item_return_id)
          .events
          .send(event_type)
          .build
      end

      def item_return(item_return_id: params[:item_return_id])
        @item_return ||= ItemReturn.includes(:events).find(item_return_id)
      end
    end
  end
end
