require 'reform'

module AdminUi
  module ReturnApprovals

    class ReceiveItemForm < ::Reform::Form
      property :event, virtual: true
      property :user
      property :location
      property :received_on
      property :event_type, writeable: false


      def event
        :received_item
      end

      def received_on
        super || Date.today
      end

      validates :event,       presence: true
      validates :user,        presence: true
      validates :location,    presence: true
      validates :received_on, presence: true
    end

    # /attributes :user, :received_on, :location
    # /
    # /validates :user,        presence: true
    # /validates :location,    presence: true
    # /validates :received_on, presence: true
    # /
    # /validate :location, inclusion: { in:  ['AU', 'US'] }



    class EventsController < AdminUi::ApplicationController
      def index
        @events = ItemReturn.find(params[:item_return_id]).events
      end

      def new
        event_type = params[:event]

        if ItemReturnEvent.event_types.include?(event_type.to_s)
          # I would prefer to use public_send here, but it causes nomethod errors on Array
          @event = ItemReturn
                     .find(params[:item_return_id])
                     .events
                     .send(event_type)
                     .build

          @form = ReceiveItemForm.new(@event)
        else

        end





      end

      def create


        event_type = params[:event]

        if ItemReturnEvent.event_types.include?(event_type.to_s)
          # I would prefer to use public_send here, but it causes nomethod errors on Array
          @event = ItemReturn
                     .find(params[:item_return_id])
                     .events
                     .send(event_type)
                     .build

          @form = ReceiveItemForm.new(@event)
        else
        end

        binding.pry



      end
    end
  end
end
