module Api
  module V1
    # TO-DO: Refactor into an ApiController
    class ReturnsProcessController < ApplicationController
      before_filter :authenticate_spree_user!, :only => [:index]

      respond_to :json


      # GET
      def index
        user = try_spree_current_user

        @orders = user.orders.complete.map do |order|
          Orders::OrderPresenter.new(order)
        end

        respond_with @orders
      end


      # POST
      def create

        if has_incorrect_params?
          error_response("Incorrect parameters. Expecting { order_id: INT, line_items: ARRAY }")
          return
        end

        if has_invalid_order_id?(params['order_id'])
          error_response("Invalid Order ID.")
          return
        end

        return_item_ids = map_line_item_ids(params['line_items'])

        if has_invalid_line_items?(return_item_ids)
          error_response("One or more line_item_ids is not valid.")
          return
        end

        if has_existing_returns?(return_item_ids)
          error_response("One or more line_item_ids already has a return.")
          return
        end

        process_returns(params)

      end


      private

      def has_incorrect_params?
        !(params['order_id'].present? && params['line_items'].present?)
      end

      def has_invalid_order_id?(id)
        !Spree::Order.exists?(id)
      end

      def map_line_item_ids(arr)
        ids = arr.map do |id|
                id['line_item_id']
              end
      end

      def has_invalid_line_items?(arr)
        arr.any? do |id|
          !Spree::LineItem.exists?(id)
        end
      end

      def has_existing_returns?(arr)
        arr.any? do |id|
          ItemReturn.exists?(line_item_id: id)
        end
      end

      def process_returns(obj)

        return_request = {
          :order_return_request => {
            :order_id => obj['order_id'],
            :return_request_items_attributes => obj['line_items']
          }
        }

        @order_return = OrderReturnRequest.new(return_request[:order_return_request])
        @order = Spree::Order.find(return_request[:order_return_request][:order_id])

        @order_return.save

        start_bergen_return_process(@order_return)
        start_next_logistics_process(@order_return)

        return_labels = map_return_labels(obj['line_items'])

        success_response(return_labels)
        return

      end

      def map_return_labels(arr)
        arr.map do |item|
          {
            "line_item_id": item['line_item_id'],
            "label_meta": ItemReturn.where(line_item_id: item['line_item_id']).first.return_label
          }
        end
      end

      def error_response(err)
        payload = {
          error: err,
          status: 400
        }
        render :json => payload, :status => :bad_request
      end

      def success_response(msg)
        payload = {
          message: msg,
          status: 200
        }
        render :json => payload, :status => :ok
      end

      def start_bergen_return_process(order_return)
        order_return.return_request_items.each do |rri|
          Bergen::Operations::ReturnItemProcess.new(return_request_item: rri).start_process
        end
      end

      def start_next_logistics_process(order_return)
        if Features.active?(:next_logistics)
          NextLogistics::ReturnRequestProcess.new(order_return_request: order_return).start_process
        end
      end

    end
  end
end
