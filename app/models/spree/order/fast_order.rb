module Spree
  class Order
    class FastOrder
      class << self

        def get_sql(options)
          case options[:report]
            when :full_orders
              select = ", #{return_action_details}"
              where = "#{options[:where]}, line_item_id ASC"
              sql(select: select, where: where)
            when :daily_orders
              select = ", #{sku}, #{custom_variant_id}, #{images}, #{product_id}, #{variant_id}"
              from = ", #{custom_variant_id_from}"
              where = "o.completed_at IS NOT NULL
              AND o.completed_at between '#{options[:from_date]}' and '#{options[:to_date]}'
              ORDER BY o.completed_at, line_item_id ASC"
              sql(with: with, select: select, from: from, where: where)
          end
        end

        private

        def sql(with: with, select: select, where: where, from: from)
          <<-SQL

            #{with}

            SELECT
            DISTINCT

            #{order_state},
            #{order_number},
            #{total_items},
            #{user_first_name},
            #{user_last_name},
            #{site_version},
            #{line_item_id},
            #{quantity},
            #{fast_making},
            #{tracking_number},
            #{completed_at},
            #{completed_at_date},
            #{shipment_date},
            #{fabrication_state},
            #{style},
            #{style_name},
            #{color},
            #{size},
            #{personalization},
            #{height},
            #{color_id},
            #{promo_codes},
            #{customization_value_ids},
            #{custom_color},
            #{factory},
            #{customer_notes},
            #{address},
            #{price},
            #{material},
            #{currency}
            #{select}

            FROM "spree_orders" o
            LEFT OUTER JOIN "spree_line_items" li ON li."order_id" = o."id"
            LEFT OUTER JOIN "spree_variants" sv ON sv."id" = li."variant_id"
            LEFT OUTER JOIN "spree_products" sp ON sp."id" = sv."product_id"
            LEFT OUTER JOIN "spree_inventory_units" siu ON siu.order_id = o.id AND siu.variant_id = sv.id
            LEFT OUTER JOIN "line_item_personalizations" lip ON lip."line_item_id" = li."id"
            LEFT OUTER JOIN "spree_shipments" ss ON ss."id" = siu.shipment_id AND ss."order_id" = o."id"
            LEFT OUTER JOIN "spree_addresses" sa ON sa."id" = o."bill_address_id"
            LEFT OUTER JOIN "spree_addresses" ssa ON ssa."id" = o."ship_address_id"
            LEFT OUTER JOIN "spree_states" ssa_s ON ssa_s."id" = ssa."state_id"
            LEFT OUTER JOIN "spree_countries" ssa_c ON ssa_c."id" = ssa."country_id"
            LEFT OUTER JOIN "fabrications" f ON f."line_item_id" = li."id"
            LEFT OUTER JOIN "factories" fa ON sp."factory_id" = fa."id"
            LEFT OUTER JOIN "fabrics" fabric ON fabric."id" = li."fabric_id"
            #{from}

            WHERE #{where}
          SQL
        end


        def order_state
          'o.state as order_state'
        end

        def order_number
          'o.number as order_number'
        end

        def site_version
          'o.site_version as site_version'
        end

        def user_first_name
          'o.user_first_name as user_first_name'
        end

        def user_last_name
          'o.user_last_name as user_last_name'
        end

        def line_item_id
          'li.id as line_item_id'
        end

        def quantity
          'li.quantity as quantity'
        end

        def total_items
          "(
              SELECT count(*) 
              FROM spree_line_items sli
              WHERE
                sli.order_id = o.id
                  AND
                sli.variant_id NOT IN (
                                        SELECT id 
                                        FROM spree_variants
                                        WHERE sku ilike 'return_insurance'
                                      )
          ) as total_items"
        end

        def completed_at
          'o.completed_at'
        end

        def completed_at_date
          'to_char(o.completed_at, \'YYYY-MM-DD\') as completed_at_date'
        end

        def tracking_number
          'ss.tracking as tracking_number'
        end

        def shipment_date
          'to_char(ss.shipped_at, \'YYYY-MM-DD\') as shipment_date'
        end

        def fabrication_state
          'CASE WHEN f.state <> \' \' THEN f.state ELSE \'processing\' END as fabrication_state'
        end

        def style
          '( SELECT "spree_variants".sku
            FROM "spree_variants"
            WHERE "spree_variants"."product_id" = sp.id
              AND
            "spree_variants"."is_master" = true LIMIT 1 ) as style'
        end

        def style_name
          'sp.name as style_name'
        end

        def personalization
          'lip.id as personalization'
        end

        def color_id
          '( SELECT id FROM spree_option_values WHERE id = lip.color_id) as color_id'
        end

        def height
          'lip.height as height'
        end

        def material
          'fabric.material as material' 
        end

        def customization_value_ids
          'lip.customization_value_ids as customization_value_ids'
        end

        def factory
          'fa.name as factory'
        end

        def address
          'o.email as email,
          sa.phone as customer_phone_number,
          ssa.address1 as address1,
          ssa.address2 as address2,
          ssa.city as city,
          ssa.zipcode as zipcode,
          ssa_s.name as state,
          ssa_c.name as country'
        end

        def customer_notes
          'o.customer_notes as customer_notes'
        end

        def sku
          'sv.sku as variant_sku,
          sv.is_master as variant_master'
        end

        def price
          'li.price,
          lip.price as personalization_price,
          ( SELECT SUM(price) FROM line_item_making_options WHERE line_item_id = li.id ) as making_options_price'
        end

        def currency
          'li.currency as currency'
        end

        def color
          "CASE WHEN lip.id > 0
              THEN (SELECT presentation FROM spree_option_values WHERE id = lip.color_id)
              ELSE (SELECT spree_option_values.presentation FROM spree_option_values
                INNER JOIN spree_option_values_variants ON spree_option_values.id = spree_option_values_variants.option_value_id
                INNER JOIN spree_option_types ON spree_option_types.id = spree_option_values.option_type_id
                WHERE spree_option_types.name = 'dress-color' AND spree_option_values_variants.variant_id = sv.id)
            END as color"
        end

        def size
          "CASE WHEN lip.id > 0
              THEN (SELECT name FROM spree_option_values WHERE id = lip.size_id)
              ELSE (SELECT spree_option_values.name FROM spree_option_values
                INNER JOIN spree_option_values_variants ON spree_option_values.id = spree_option_values_variants.option_value_id
                INNER JOIN spree_option_types ON spree_option_types.id = spree_option_values.option_type_id
                WHERE spree_option_types.name = 'dress-size' AND spree_option_values_variants.variant_id = sv.id)
            END as size"
        end

        def promo_codes
          "( SELECT string_agg('[' || sa.code || '] ' || sa.name, '|') FROM spree_adjustments sadj
            INNER JOIN spree_promotion_actions spa ON spa.id = sadj.originator_id
            INNER JOIN spree_activators sa ON sa.id = spa.activator_id
            WHERE sadj.adjustable_id = o.id AND sadj.adjustable_type = 'Spree::Order'
              AND sadj.originator_type = 'Spree::PromotionAction' AND sa.type IN ('Spree::Promotion')
            GROUP BY sadj.adjustable_id ) as promo_codes"
        end

        def fast_making
          "( SELECT pmo.id FROM line_item_making_options ilmo
              INNER JOIN product_making_options pmo ON ilmo.making_option_id = pmo.id
              WHERE ilmo.line_item_id = li.id AND pmo.option_type = 'fast_making' ) as fast_making"
        end

        def custom_color
          "CASE WHEN lip.id > 0
              THEN (SELECT DISTINCT(sov.id) FROM spree_option_values sov
                INNER JOIN spree_option_values_variants sovv ON sov.id = sovv.option_value_id
                INNER JOIN spree_option_types sot ON sot.id = sov.option_type_id
                WHERE
                  sot.name IN ('dress-color', 'dress-custom-color')
                  AND sovv.variant_id IN (SELECT DISTINCT(spree_variants.id) FROM spree_variants
                    WHERE spree_variants.product_id = sp.id AND spree_variants.is_master = false AND spree_variants.deleted_at IS NULL)
                  AND sov.id = lip.color_id)
              ELSE NULL
              END as custom_color"
        end

        def return_action_details
          "( SELECT string_agg(rri.action, ' | ') || '/' || string_agg(rri.quantity || ' x ' || rri.reason_category ||  ' - ' || rri.reason, ' | ')
              FROM return_request_items rri
              WHERE rri.line_item_id = li.id AND rri.action IN ('return', 'exchange')
              GROUP BY rri.line_item_id ) as return_action_details"
        end

        def images
          "( SELECT product_images.id || '/large/' || product_images.attachment_file_name
          FROM product_images
          WHERE
            (
              (product_images.viewable_id IN
                ( SELECT DISTINCT(pcv.id)
                  FROM product_color_values pcv
                  WHERE
                    pcv.product_id = sp.id
                  AND
                    pcv.option_value_id IN
                            ( SELECT DISTINCT(option_value_id)
                              FROM spree_option_values_variants
                              WHERE variant_id = sv.id))
                  AND
                    product_images.viewable_type = 'ProductColorValue')
            OR
              (product_images.viewable_id = sv.id AND product_images.viewable_type = 'Spree::Variant')
            )
          LIMIT 1) as variant_image,

        CASE WHEN lip.id > 0
          THEN
            ( SELECT product_images.id || '/large/' || product_images.attachment_file_name
              FROM product_images
              WHERE
                (
                  (product_images.viewable_id IN
                    ( SELECT DISTINCT(pcv.id)
                      FROM product_color_values pcv
                      WHERE
                        pcv.product_id = sp.id
                      AND
                        pcv.option_value_id IN
                          ( SELECT DISTINCT(option_value_id)
                            FROM spree_option_values_variants
                            WHERE variant_id = custom_variant_id))
                      AND
                        product_images.viewable_type = 'ProductColorValue')
                OR
                  (product_images.viewable_id = custom_variant_id AND product_images.viewable_type = 'Spree::Variant')
                )
              LIMIT 1)
          ELSE NULL
          END as custom_variant_image,

        ( SELECT product_images.id || '/large/' || product_images.attachment_file_name
          FROM product_images
          WHERE
            (
              (product_images.viewable_id IN
                ( SELECT DISTINCT(product_color_values.id)
                  FROM product_color_values
                  WHERE
                  product_color_values.product_id = sp.id
                ) AND product_images.viewable_type = 'ProductColorValue')
            OR
              (product_images.viewable_id IN
                ( SELECT DISTINCT(spree_variants.id)
                  FROM spree_variants
                  WHERE
                  spree_variants.product_id = sp.id AND spree_variants.deleted_at IS NULL
                ) AND product_images.viewable_type = 'Spree::Variant')
            )
          LIMIT 1) as product_image"
        end

        def custom_variant_id
          's1.custom_variant_id as custom_variant_id'
        end

        def variant_id
          'sv.id as variant_id'
        end

        def product_id
          'sv.product_id as product_id'
        end

        def custom_variant_id_from
          "LATERAL( SELECT
          CASE WHEN lip.id > 0
          THEN (SELECT sovv.variant_id FROM spree_option_values sov
            INNER JOIN spree_option_values_variants sovv ON sov.id = sovv.option_value_id
            WHERE
              sovv.variant_id IN (SELECT spree_variants.id FROM spree_variants
                WHERE spree_variants.product_id = sp.id AND spree_variants.is_master = 'f' AND spree_variants.deleted_at IS NULL)
              AND sov.id = lip.color_id
              LIMIT 1)
          ELSE NULL
          END as custom_variant_id) s1"
        end

        def with
          "WITH product_images AS
            (
              SELECT _sa.*
              FROM spree_assets _sa
              WHERE (_sa.viewable_type = 'Spree::Variant' OR _sa.viewable_type = 'ProductColorValue')
              AND lower(_sa.attachment_file_name) LIKE '%front-crop%'
            )"
        end

      end
    end
  end
end
