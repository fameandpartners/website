module Api
  module V1
    # TO-DO: Refactor into an ApiController
    class ReturnsProcessesController < ApplicationController
      include Spree::Core::ControllerHelpers::Auth

      respond_to :json


      # GET
      def index
        @orders = spree_current_user.orders.joins(line_items: [:personalization, :variant, :item_return]).eager_load(line_items: [:personalization, :variant, :item_return]).map do |order|
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

        if has_nonreturnable_line_items?(return_item_ids)
          error_response(@error_message_code["CONTACT"])
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


      private

      def get_user
        if params['email'].present?
          Spree::User.where(email: params['email']).first
        else
          spree_current_user
        end
      end

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

      def has_nonexistent_line_items?(arr)
        arr.any? do |id|
          !Spree::LineItem.exists?(id)
        end
      end

      def has_nonreturnable_line_items?(arr)
        arr.any? do |id|
          !Spree::LineItem.where(id: id).first&.can_dress_be_returned?
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

      def process_returns(obj, return_label)
        return_request = {
          :order_return_request => {
            :order_id => obj[:order_id],
            :return_request_items_attributes => obj[:line_items]
          }
        }

        @order_return = OrderReturnRequest.new(return_request[:order_return_request])

        @order_return.save

        @order_return.return_request_items.each do |x|
          x.item_return.item_return_label = return_label
        end

        @order_return.save

        start_bergen_return_process(@order_return)
        start_next_logistics_process(@order_return)

        return_labels = map_return_labels(obj[:line_items])

        success_response(return_labels)
        return
      end


      def create_label(order_id)
        order = Spree::Order.find(order_id)

        label = Newgistics::ShippingLabel.new(
          order.user_first_name,
          order.user_last_name,
          order.billing_address,
          order.email,
          order.number
        )

        if(label.fetch_shipping_label_from_api().nil?)
           return nil
        end

        item_return_label = ItemReturnLabel.new(
          :label_image_url => label.label_image_url,
          :label_pdf_url => label.label_pdf_url,
          :label_url => label.label_url,
          :carrier => label.carrier
          )
      end

      def map_return_labels(arr)
        arr.map do |item|
          {
            "line_item_id": item['line_item_id']
          }.merge(ItemReturn.where(line_item_id: item['line_item_id']).first&.item_return_label.as_json)
        end
      end

      def error_response(err)
        payload = {
          error: err,
          status: 400
        }
        respond_with err do |format|
          format.json do
            render :json => payload, :status => :bad_request
          end
        end
      end

      def success_response(msg)
        payload = {
          message: msg,
          status: 200
        }
        respond_with msg do |format|
          format.json do
            render :json => payload, :status => :ok
          end
        end
      end

      def start_bergen_return_process(order_return)
        order_return.return_request_items.each do |rri|
          Bergen::Operations::ReturnItemProcess.new(return_request_item: rri).start_process
        end

        ReturnMailer.notify_user(order_return).deliver
      end

      def start_next_logistics_process(order_return)
        if Features.active?(:next_logistics)
          NextLogistics::ReturnRequestProcess.new(order_return_request: order_return).start_process
        end
      end

    end
  end
end
