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

        # per_page = 5000 if params[:format] == 'csv'
        if params[:format] != 'csv'
          @orders = @search.result(distinct: true).includes(
            :user => [],
            :shipments => {:inventory_units => :variant},
            :payments => [],
            :line_items => {:variant => :product, :fabrication => [], :making_options => []},
            :bill_address => [:state, :country],
            :ship_address => [:state, :country]
          ).page(page).per(per_page)
        else
          @orders = Spree::LineItem.find_by_sql <<-SQL
            SELECT

            o.id as order_id,
            o.state as order_state,
            o.number as order_number,
            o.user_first_name,
            o.user_last_name,
            o.site_version,
            li.id as line_item_id,
            (SELECT count(*) FROM spree_line_items sli WHERE sli."order_id" = o."id") as total_items,
            to_char(o.completed_at, 'YYYY-MM-DD') as completed_at_char,
            to_char(o.projected_delivery_date, 'YYYY-MM-DD') as projected_delivery_date_char,
            ss.tracking as tracking_number,
            to_char(ss.shipped_at, 'YYYY-MM-DD') as shipment_date,
            case when f.state <> '' then f.state else 'processing' end as fabrication_state,
            sv.sku as style,
            sp.name as style_name,
            case when lip.id > 0
              then (SELECT name FROM spree_option_values WHERE id = lip.color_id)
              else (SELECT spree_option_values.name FROM spree_option_values
                INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
                INNER JOIN "spree_option_types" ON "spree_option_types".id = "spree_option_values"."option_type_id"
                WHERE "spree_option_types"."name" = 'dress-color' AND "spree_option_values_variants"."variant_id" = sv.id)
            end as color,
            case when lip.id > 0
              then (SELECT name FROM spree_option_values WHERE id = lip.size_id)
              else (SELECT spree_option_values.name FROM spree_option_values
                INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
                INNER JOIN "spree_option_types" ON "spree_option_types".id = "spree_option_values"."option_type_id"
                WHERE "spree_option_types"."name" = 'dress-size' AND "spree_option_values_variants"."variant_id" = sv.id)
            end as size,
            lip.height as height,
            case when fa.name <> '' then fa.name else 'Unknown' end as factory,
            o.email,
            o.customer_notes,
            case when sa.phone <> '' then sa.phone else 'No Phone' end as customer_phone_number,
            li.price,
            li.currency

            FROM "spree_orders" o
            LEFT OUTER JOIN "spree_addresses" sa ON sa."id" = o."bill_address_id"
            LEFT OUTER JOIN "spree_line_items" li ON li."order_id" = o."id"
            LEFT OUTER JOIN "line_item_personalizations" lip ON lip."line_item_id" = li."id"
            LEFT OUTER JOIN "spree_variants" sv ON sv."id" = li."variant_id"
            LEFT OUTER JOIN "spree_products" sp ON sp."id" = sv."product_id"
            LEFT OUTER JOIN "fabrications" f ON f."line_item_id" = li."id"
            LEFT OUTER JOIN "factories" fa ON sp."factory_id" = fa."id"
            LEFT OUTER JOIN "spree_shipments" ss ON ss."order_id" = o."id"

            WHERE ((sa."firstname" ILIKE 'anna%' AND sa."lastname" ILIKE 'p%' AND o."completed_at" IS NOT NULL))
            ORDER BY o."completed_at" DESC
          SQL
        end


        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
        ##################### End Original Spree ##############################

        # ransack_clause = Spree::Order.select('spree_orders.id').ransack(params[:q]).result.to_sql
        # puts ransack_clause

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
