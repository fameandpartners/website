module Api
  module V1
    # TO-DO: Refactor into an ApiController
    class ReturnsProcessesController < ApplicationController
      include Spree::Core::ControllerHelpers::Auth
      include ReturnsProcessesControllerHelper

      respond_to :json


      # GET
      def index
        @orders = spree_current_user.orders.joins(:line_items).eager_load(line_items: [:personalization, :variant, :item_return]).complete.map do |order|
          Orders::OrderPresenter.new(order, order.line_items)
        end

        respond_with @orders
      end

      # GET (guest)
      def guest
        if has_incorrect_guest_params?
          error_response("Incorrect parameters. Expecting { email: STRING, order_number: STRING }.")
          return
        end

        fetched_order = Spree::Order.where(email: params['email'], number: params['order_number']).first

        if fetched_order.present?
          respond_with Orders::OrderPresenter.new(fetched_order)
        else
          error_response("No order found.")
          return
        end
      end


      # POST
      def create
        @error_message_code = {
          "RETRY" => "Please try again.",
          "CONTACT" => "Something's wrong, please contact customer service.",
          "RETURN_EXISTS" => "These items already have a return.",
          "NO_ITEMS_SELECTED" => "Please select an item you would like to return."
        }

        @user = get_user()

        if @user.nil?
          error_response(@error_message_code["RETRY"])
        end

        if has_incorrect_params?
          error_response(@error_message_code["NO_ITEMS_SELECTED"])
          return
        end

        request_object = {
          "order_id": params['order_id']&.to_i,
          "line_items": params['line_items'].values
        }

        if has_invalid_order_id?(request_object[:order_id])
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_incorrect_order_id?(request_object[:order_id])
          error_response(@error_message_code["RETRY"])
          return
        end

        return_item_ids = request_object[:line_items].map do |id|
                            id['line_item_id'].to_i
                          end

        if has_nonexistent_line_items?(return_item_ids)
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_incorrect_line_items?(return_item_ids, request_object[:order_id])
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_existing_returns?(return_item_ids)
          error_response(@error_message_code["RETURN_EXISTS"])
          return
        end

        unless(return_label = create_label(request_object[:order_id]))
          error_response(@error_message_code["RETRY"])
          return
        end

        process_returns(request_object, return_label)
      end
    end
  end
end
