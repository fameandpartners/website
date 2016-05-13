module Spree
  module Admin
    class ShipmentsController < Spree::Admin::BaseController
      before_filter :load_shipping_methods, :except => [:country_changed, :index]

      respond_to :html

      def index
        @shipments = order.shipments
        respond_with(@shipments)
      end

      def new
        build_shipment
        respond_with(shipment)
      end

      def create
        build_shipment
        assign_inventory_units
        if shipment.save
          flash[:success] = flash_message_for(shipment, :successfully_created)
          respond_with(shipment) do |format|
            format.html { redirect_to edit_admin_order_shipment_path(order, shipment) }
          end
        else
          respond_with(shipment) { |format| format.html { render :action => 'new' } }
        end
      end

      def edit
        shipment.special_instructions = order.special_instructions
        respond_with(shipment)
      end

      def update
        assign_inventory_units
        if shipment.update_attributes params[:shipment]
          # copy back to order if instructions are enabled
          order.special_instructions = params[:shipment][:special_instructions] if Spree::Config[:shipping_instructions]
          order.shipping_method = order.shipment.shipping_method
          order.save

          flash[:success] = flash_message_for(shipment, :successfully_updated)
          return_path = order.completed? ? edit_admin_order_shipment_path(order, shipment) : admin_order_adjustments_path(order)
          respond_with(@object) do |format|
            format.html { redirect_to return_path }
          end
        else
          respond_with(shipment) { |format| format.html { render :action => 'edit' } }
        end
      end

      def destroy
        shipment.destroy
        respond_with(shipment) { |format| format.js { render_js_for_destroy } }
      end

      def fire
        if shipment.send("#{params[:e]}")
          flash[:success] = t(:shipment_updated)
        else
          flash[:error] = t(:cannot_perform_operation)
        end

        respond_with(shipment) { |format| format.html { redirect_to :back } }
      end

      private

      def load_shipping_methods
        @shipping_methods = ShippingMethod.all_available(order, :back_end)
      end

      def assign_inventory_units
        return unless params.has_key? :inventory_units
        shipment.inventory_unit_ids = params[:inventory_units].keys
      end

      def order
        @order ||= Order.find_by_number(params[:order_id])
        authorize! action, @order
      end

      def shipment
        @shipment ||= order.shipments.find_by_number(params[:id])
      end

      def build_shipment
        @shipment = order.shipments.build
        @shipment.address ||= order.ship_address
        @shipment.address ||= Address.new(:country_id => Spree::Config[:default_country_id])
        @shipment.shipping_method ||= order.shipping_method
        @shipment.attributes = params[:shipment]
      end

      def model_class
        Spree::Shipment
      end
    end
  end
end
