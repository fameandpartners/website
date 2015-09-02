module Spree
  module Admin
    module Orders
      class CustomerDetailsController < Spree::Admin::BaseController
        before_filter :load_order

        def show
          edit
          render :action => :edit
        end

        def edit
          country_id = Address.default.country.id
          @order.build_bill_address(:country_id => country_id) if @order.bill_address.nil?
          @order.build_ship_address(:country_id => country_id) if @order.ship_address.nil?
        end

        def update
          new_user_id = params[:order].delete(:user_id)

          if @order.update_attributes(params[:order])
            #shipping_method = @order.available_shipping_methods(:front_end).first
            #if @order.shipping_method
              #@order.shipping_method = shipping_method

            if @order.available_shipping_methods(:back_end).present?
              if new_user_id
                ::Admin::ChangeOrderOwner.new(
                  site_version: current_site_version,
                  new_owner_id: new_user_id,
                  order: @order
                ).process
              end

              while @order.next; end

              flash[:success] = t('customer_details_updated')

              if @order.shipment
                redirect_to edit_admin_order_shipment_path(@order, @order.shipment)
              else
                redirect_to new_admin_order_shipment_path(@order)
              end

            else
              flash[:error] = t('errors.messages.no_shipping_methods_available')
              redirect_to admin_order_customer_path(@order)
            end

          else
            render :action => :edit
          end

        end

        private

          def load_order
            @order = Order.find_by_number!(params[:order_id], :include => :adjustments)
          end

      end
    end
  end
end
