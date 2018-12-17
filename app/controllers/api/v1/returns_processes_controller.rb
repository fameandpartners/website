module Api
  module V1
    # TO-DO: Refactor into an ApiController
    class ReturnsProcessesController < Api::ApiBaseController
      include Spree::Core::ControllerHelpers::Auth
      include ReturnsProcessesControllerHelper

      respond_to :json


      # GET
      def index

        if current_spree_user.nil?
          return
        end

        @orders = current_spree_user.orders.hydrated.complete

        respond_with @orders, each_serializer: OrderSerializer
      end

      # GET (guest)
      def guest
        if has_incorrect_guest_params?
          error_response(:INCORRECT_GUEST_PARAMS)
          return
        end

        fetched_order = Spree::Order.where('lower(email) = ? AND number = ?', params['email'].downcase, params['order_number']).first

        if fetched_order.present?
          respond_with fetched_order, each_serializer: OrderSerializer
        else
          error_response(:GUEST_ORDER_NOT_FOUND)
          return
        end
      end


      # POST
      def create
        @user = get_user()

        if @user.nil?
          error_response(:RETRY, :USER_NOT_FOUND)
          return
        end

        if has_incorrect_params?
          error_response(:NO_ITEMS_SELECTED, :INCORRECT_PARAMS)
          return
        end

        request_object = {
          "order_number": params[:order_number],
          "line_items": params[:line_items]
        }

        if has_invalid_order_number?(request_object[:order_number])
          error_response(:RETRY, :INVALID_ORDER_ID)
          return
        end

        if has_incorrect_order_number?(request_object[:order_number])
          error_response(:RETRY, :INCORRECT_ORDER_ID)
          return
        end

        return_item_ids = request_object[:line_items].map do |id|
                            id['line_item_id'].to_i
                          end

        if has_nonexistent_line_items?(return_item_ids)
          error_response(:RETRY, :NON_EXISTENT_LINE_ITEMS)
          return
        end

        if has_incorrect_line_items?(return_item_ids, request_object[:order_number])
          error_response(:RETRY, :INCORRECT_LINE_ITEMS)
          return
        end

        if has_existing_returns?(return_item_ids)
          error_response(:RETURN_EXISTS)
          return
        end
        if (has_us_shipping_address?(request_object[:order_number]))
          unless(return_label = ReturnsProcessesControllerHelper.create_label(request_object[:order_number]))
            error_response(:RETRY, :LABEL_FAILED)
            return
          end
        end

        process_returns(request_object, return_label)
      end
    end
  end
end
