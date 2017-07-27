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
          error_response("Incorrect parameters. Expecting { line_item_ids: ARRAY }")
          return
        end

        return_item_ids = params['line_item_ids']

        if has_invalid_line_items?(return_item_ids)
          error_response("One or more line_item_ids is not valid.")
          return
        end

        if has_existing_returns?(return_item_ids)
          error_response("One or more line_item_ids already has a return.")
          return
        end

        process_returns(return_item_ids)

      end


      def has_incorrect_params?
        !(params['line_item_ids'].present? && (params['line_item_ids'].instance_of? Array))
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


      def process_returns(arr)
        new_return_labels = arr.map do |id|
          ItemReturnEvent.creation.create(line_item_id: id).item_return.return_label
        end
        success_response(new_return_labels)
        return
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

    end
  end
end
