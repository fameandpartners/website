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
              if new_user_id && new_user_id != @order.user_id
                update_order_owner(@order, new_user_id)
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

          # only update, will not delete owner
          def update_order_owner(order, owner_id)
            previous_user = order.user
            owner = Spree::User.find_by_id(owner_id)
            return false if owner.blank?

            order.user_id = owner.id
            order.user

            # update user-related details
            order.user_first_name = owner.first_name
            order.user_last_name  = owner.first_name
            order.email           = owner.email

            if order.save
              tracker = Marketing::CustomerIOEventTracker.new
              tracker.identify_user(owner, current_site_version)
              tracker.track(owner, 'order:new_owner', {
                order_number: order.number,
                original_customer_email: previous_user.try(:email),
                updated_customer_email: owner.try(:email)
              })
            end

            owner
          end
      end
    end
  end
end
