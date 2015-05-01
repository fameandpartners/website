module Spree
  module Admin
    OrdersController.class_eval do
      include Concerns::Paginated
      respond_to :csv, only: :index

      attr_reader :hide_line_items
      helper_method :hide_line_items

      def index
        ##################### Original Spree ##############################
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
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

        if @show_only_completed
          params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
          params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
        end

        @search = Order.accessible_by(current_ability, :index).ransack(params[:q])
        @orders = @search.result(distinct: true).includes([:user, :shipments, :payments]).
            page(page).
            per(per_page)

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
        ##################### End Original Spree ##############################

        respond_with(@orders) do |format|
          format.html
          format.csv {
            presenter = ::Orders::LineItemCsvGenerator.new(@orders, params[:q])
            headers['Content-Disposition'] = "attachment; filename=#{presenter.filename}"
            render :text => presenter.to_csv
          }
        end
      end

      private

      def hide_line_items
        params[:q][:hide_line_items].present?
      end

      def default_per_page
        Spree::Config[:orders_per_page]
      end
    end
  end
end
