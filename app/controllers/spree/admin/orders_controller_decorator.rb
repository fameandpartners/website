module Spree
  module Admin
    OrdersController.class_eval do
      include Concerns::Paginated
      respond_to :csv, only: :index

      attr_reader :hide_line_items
      helper_method :hide_line_items, :order_shipment_states

      def mark_order_as_shipped
        if @order.can_ship?
          @order.shipment_state = 'shipped'
          @order.save!
          flash[:success] = 'Order was marked as shipped!'
        else
          flash[:error] = 'Order cannot be marked as shipped'
        end

        redirect_to action: :show
      end

      def index
        ##################### Original Spree ##############################
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]

        if params[:q][:making_only].present?
          @making_only = true
          params[:q][:completed_at_not_null] = '1'
        end
        params[:q].delete(:making_only)

        @show_only_completed = params[:q][:completed_at_not_null].present?
        params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
        # As date params are deleted if @show_only_completed, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

        if !params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
        end

        if !params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        end

        @sample_only = params[:q][:sample_sale_only].present?
        params[:q].delete(:sample_sale_only)

        @refulfill_only = params[:q][:refulfill_only].present?
        params[:q].delete(:refulfill_only)

        @batch_only = params[:q][:batch_only].present?
        params[:q].delete(:batch_only)

        @ready_batches = params[:q][:ready_batches].present?
        params[:q].delete(:ready_batches)

        if @show_only_completed
          params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
          params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
        end

        @search = Order.accessible_by(current_ability, :index).ransack(params[:q])
        ##################### End Original Spree ##############################

        @orders = @search.result(distinct: true).hydrated.page(request.format.csv? ? 0 : page).per(request.format.csv? ? 9999999 : per_page)

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt

        respond_with(@orders) do |format|
          format.html
          format.csv {
            if @show_only_completed
              params[:q][:show_only_completed]
            end
            if @refulfill_only
              params[:q][:refulfill_only] = true
            end
            if @batch_only
              params[:q][:batch_only] = true
            end
            if @ready_batches
              params[:q][:ready_batches] = true
            end
            if @making_only
              params[:q][:making_only] = true
            end
            presenter = ::Orders::LineItemCsvGenerator.new(@orders, params[:q])
            headers['Content-Disposition'] = "attachment; filename=#{presenter.filename}"
            render :text => presenter.to_csv
          }
        end
      end

      private

      def order_shipment_states
        @order_shipment_states ||= Spree::Order.shipment_states
      end

      def hide_line_items
        params[:q][:hide_line_items].present?
      end

      def default_per_page
        15 # Spree::Config[:orders_per_page]
      end
    end
  end
end
