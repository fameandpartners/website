module Api
  module V1
    # TO-DO: Refactor into an ApiController
    class ReturnsProcessesController < ApplicationController
      include Spree::Core::ControllerHelpers::Auth

      respond_to :json


      # GET
      def index
        user = spree_current_user
        @orders = user.orders.complete.map do |order|
          Orders::OrderPresenter.new(order)
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
        # TODO: REMOVE
        process_returns(params)
        return

        @error_message_code = {
          "RETRY" => "Please try again.",
          "RETURN_EXISTS" => "These items already have a return."
        }

        @user = spree_current_user

        if has_incorrect_params?
          error_response("Incorrect parameters. Expecting { order_id: INT, line_items: ARRAY }.")
          return
        end

        if has_invalid_order_id?(params['order_id'])
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_incorrect_order_id?(params['order_id'])
          error_response(@error_message_code["RETRY"])
          return
        end

        return_item_ids = params['line_items'].map do |id|
                            id['line_item_id']
                          end

        if has_invalid_line_items?(return_item_ids)
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_incorrect_line_items?(return_item_ids, params['order_id'])
          error_response(@error_message_code["RETRY"])
          return
        end

        if has_existing_returns?(return_item_ids)
          error_response(@error_message_code["RETURN_EXISTS"])
          return
        end

        # process_returns(params)
      end


      private

      def has_incorrect_guest_params?
        !(params['email'].present? && params['order_number'].present?)
      end

      def has_incorrect_params?
        !(params['order_id'].present? && params['line_items'].present?)
      end

      def has_invalid_order_id?(id)
        !Spree::Order.exists?(id)
      end

      def has_incorrect_order_id?(id)
        !@user.orders.where(id: id).first
      end

      def has_invalid_line_items?(arr)
        arr.any? do |id|
          !Spree::LineItem.exists?(id)
        end
      end

      def has_incorrect_line_items?(arr, order)
        arr.any? do |id|
          Spree::LineItem.where(id: id).first&.order_id != order
        end
      end

      def has_existing_returns?(arr)
        arr.any? do |id|
          ItemReturn.exists?(line_item_id: id)
        end
      end

      def process_returns(obj)
        # TODO: REMOVE
        # return_request = [{
        #       :line_item_id => 316051,
        # "item_return_label" => {
        #             "carrier" => "USPS",
        #          "created_at" => "Wed, 02 Aug 2017 11:37:42 PDT -07:00",
        #                  "id" => 2,
        #      "item_return_id" => 316051,
        #     "label_image_url" => "https://apiint.newgistics.com/WebAPI/Shipment/D5BFE2D718928D5C180E0FCB74F0FA15DE7AC47B757907E5/label/image",
        #       "label_pdf_url" => "https://apiint.newgistics.com/WebAPI/Shipment/D5BFE2D718928D5C180E0FCB74F0FA15DE7AC47B757907E5/label/pdf",
        #           "label_url" => "http://www.preview.shipmentmanager.com/V3/PrintWebLabel.aspx?weblabelid=D2C3713B1806A9632332DE503F4DFE8D20FB14076E262EDE",
        #          "updated_at" => "Wed, 02 Aug 2017 11:37:42 PDT -07:00"
        #      }
        # }]
        # success_response(return_request)
        #
        #
        return_request = {
          :order_return_request => {
            :order_id => obj['order_id'],
            :return_request_items_attributes => obj['line_items']
          }
        }

        @order_return = OrderReturnRequest.new(return_request[:order_return_request])
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
            "line_item_id": item['line_item_id']
          }.merge(ItemReturn.where(line_item_id: item['line_item_id']).first&.return_label.as_json)
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