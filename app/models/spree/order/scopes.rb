module Spree
  class Order
    module Scopes
      def completed
        self.where(arel_table[:completed_at].not_eq(nil))
      end

      def shipment_states
        # This is literally 1000 times faster than `uniq.pluck(:shipment_state)`
        # See https://wiki.postgresql.org/wiki/Loose_indexscan
        qry = <<-SQL
          WITH RECURSIVE t AS (
               SELECT min(shipment_state) AS shipment_state FROM spree_orders
               UNION ALL
               SELECT (SELECT min(shipment_state) FROM spree_orders WHERE shipment_state > t.shipment_state)
               FROM t WHERE t.shipment_state IS NOT NULL
               )
            SELECT shipment_state FROM t WHERE shipment_state IS NOT NULL
        SQL
        find_by_sql(qry).collect(&:shipment_state)
      end

      def admin_filter(criterias)
        qry = <<-SQL
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
          fa.name as factory,
          o.email,
          o.customer_notes,
          sa.phone as customer_phone_number,
          ssa.address1 as address1,
          ssa.address2,
          ssa.city,
          ssa.zipcode,
          ssa_s.name as state,
          ssa_c.name as country,
          ( SELECT string_agg(rri.action, ' | ') || '/' || string_agg(rri.quantity || ' x ' || rri.reason_category ||  ' - ' || rri.reason, ' | ')
            FROM return_request_items rri
            WHERE rri.line_item_id = li.id AND rri.action IN ('return', 'exchange')
            GROUP BY rri.line_item_id ) as return_action_details,
          li.price,
          li.currency

          FROM "spree_orders" o
          LEFT OUTER JOIN "spree_addresses" sa ON sa."id" = o."bill_address_id"
          LEFT OUTER JOIN "spree_addresses" ssa ON ssa."id" = o."ship_address_id"
          LEFT OUTER JOIN "spree_states" ssa_s ON ssa_s."id" = ssa."state_id"
          LEFT OUTER JOIN "spree_countries" ssa_c ON ssa_c."id" = ssa."country_id"
          LEFT OUTER JOIN "spree_line_items" li ON li."order_id" = o."id"
          LEFT OUTER JOIN "line_item_personalizations" lip ON lip."line_item_id" = li."id"
          LEFT OUTER JOIN "spree_variants" sv ON sv."id" = li."variant_id"
          LEFT OUTER JOIN "spree_products" sp ON sp."id" = sv."product_id"
          LEFT OUTER JOIN "fabrications" f ON f."line_item_id" = li."id"
          LEFT OUTER JOIN "factories" fa ON sp."factory_id" = fa."id"
          LEFT OUTER JOIN "spree_shipments" ss ON ss."order_id" = o."id"

          WHERE #{criterias}
        SQL

        find_by_sql(qry)
      end
    end
  end
end
