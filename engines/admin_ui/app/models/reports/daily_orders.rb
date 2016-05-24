module Reports
  class DailyOrders
    include RawSqlCsvReport

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    end

    def from
      @from.to_s
    end

    def to
      @to.to_s
    end

    def description
      'Daily Orders'
    end

    def to_sql
      <<-SQL
        SELECT

        o.number as order_number,
        o.site_version,
        (SELECT count(*) FROM spree_line_items sli WHERE sli."order_id" = o."id") as total_items,
        ( SELECT string_agg('[' || sa.code || '] ' || sa.name, '|') FROM spree_adjustments sadj
          INNER JOIN spree_promotion_actions spa ON spa.id = sadj.originator_id
          INNER JOIN spree_activators sa ON sa.id = spa.activator_id
          WHERE sadj.adjustable_id = o.id AND sadj."adjustable_type" = 'Spree::Order' AND sadj.originator_type = 'Spree::PromotionAction' AND sa.type IN ('Spree::Promotion')
          GROUP BY sadj.adjustable_id ) as promo_codes,
        li.price,
        lip.price as personalization_price,
        ( SELECT SUM(price) FROM line_item_making_options WHERE line_item_id = li.id ) as making_options_price,
        li.currency,
        (SELECT "spree_variants".sku FROM "spree_variants" WHERE "spree_variants"."product_id" = sp.id AND "spree_variants"."is_master" = 't' LIMIT 1) as style,
        li.id as line_item_id,
        sp.id as product_number,
        CASE WHEN lip.id > 0
          THEN (SELECT name FROM spree_option_values WHERE id = lip.size_id)
          ELSE (SELECT spree_option_values.name FROM spree_option_values
            INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
            INNER JOIN "spree_option_types" ON "spree_option_types".id = "spree_option_values"."option_type_id"
            WHERE "spree_option_types"."name" = 'dress-size' AND "spree_option_values_variants"."variant_id" = sv.id)
        END as size,
        lip.height as height,
        CASE WHEN lip.id > 0
          THEN (SELECT name FROM spree_option_values WHERE id = lip.color_id)
          ELSE (SELECT spree_option_values.name FROM spree_option_values
            INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
            INNER JOIN "spree_option_types" ON "spree_option_types".id = "spree_option_values"."option_type_id"
            WHERE "spree_option_types"."name" = 'dress-color' AND "spree_option_values_variants"."variant_id" = sv.id)
        END as color,
        li.quantity as quantity,
        fa.name as factory,
        to_char(o.completed_at, 'YYYY-MM-DD') as completed_at_char,
        ( SELECT pmo.id FROM line_item_making_options ilmo
          INNER JOIN product_making_options pmo ON ilmo.making_option_id = pmo.id
          WHERE ilmo.line_item_id = li.id AND pmo.option_type = 'fast_making' ) as fast_making,
        ( SELECT id FROM spree_option_values WHERE id = lip.color_id) as color_id,
        lip.customization_value_ids as customization_value_ids,
        o.user_first_name,
        o.user_last_name,
        ss.tracking as tracking_number,
        to_char(ss.shipped_at, 'YYYY-MM-DD') as shipment_date,
        CASE WHEN f.state <> '' THEN f.state ELSE 'processing' END as fabrication_state,
        sp.name as style_name,
        CASE WHEN lip.id > 0
          THEN (SELECT DISTINCT(sov.id) FROM "spree_option_values" sov
            INNER JOIN "spree_option_values_variants" sovv ON "sov"."id" = sovv."option_value_id"
            INNER JOIN "spree_option_types" sot ON sot.id = sov."option_type_id"
            WHERE
              sot."name" IN ('dress-color', 'dress-custom-color')
              AND sovv.variant_id IN (SELECT "spree_variants".id FROM "spree_variants"
                WHERE "spree_variants".product_id = sp.id AND "spree_variants"."is_master" = 'f' AND "spree_variants"."deleted_at" IS NULL)
              AND sov.id = lip.color_id)
          ELSE NULL
          END as custom_color,
        o.email,
        o.customer_notes,
        sa.phone as customer_phone_number,
        ssa.address1 as address1,
        ssa.address2,
        ssa.city,
        ssa.zipcode,
        ssa_s.name as state,
        ssa_c.name as country,

        ( SELECT "spree_assets".id || '/large/' || "spree_assets".attachment_file_name
          FROM "spree_assets"
          WHERE
            (
              ("spree_assets".viewable_id IN
                ( SELECT pcv.id
                  FROM "product_color_values" pcv
                  WHERE
                  pcv.product_id = sp.id
                  AND
                  pcv.option_value_id IN (SELECT "spree_option_values".id FROM "spree_option_values"
                    INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
                          WHERE "spree_option_values_variants".variant_id = sv.id)) AND "spree_assets".viewable_type = 'ProductColorValue')
            OR
              ("spree_assets".viewable_id = sv.id AND "spree_assets".viewable_type = 'Spree::Variant')
            )
          AND
            lower("spree_assets".attachment_file_name) LIKE '%front-crop%'
          LIMIT 1) as variant_image,

        CASE WHEN lip.id > 0
          THEN
            ( SELECT "spree_assets".id || '/large/' || "spree_assets".attachment_file_name
              FROM "spree_assets"
              WHERE
                (
                  ("spree_assets".viewable_id IN
                    ( SELECT pcv.id
                      FROM "product_color_values" pcv
                      WHERE
                      pcv.product_id = sp.id
                      AND
                      pcv.option_value_id IN (SELECT "spree_option_values".id FROM "spree_option_values"
                        INNER JOIN "spree_option_values_variants" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id"
                              WHERE "spree_option_values_variants".variant_id = custom_variant_id)) AND "spree_assets".viewable_type = 'ProductColorValue')
                OR
                  ("spree_assets".viewable_id = custom_variant_id AND "spree_assets".viewable_type = 'Spree::Variant')
                )
              AND
                lower("spree_assets".attachment_file_name) LIKE '%front-crop%'
              LIMIT 1)
          ELSE NULL
          END as custom_variant_image,

        ( SELECT "spree_assets".id || '/large/' || "spree_assets".attachment_file_name
          FROM "spree_assets"
          WHERE
            (
              ("spree_assets".viewable_id IN
                ( SELECT "product_color_values".id
                  FROM "product_color_values"
                  WHERE
                  "product_color_values".product_id = sp.id
                ) AND "spree_assets".viewable_type = 'ProductColorValue')
            OR
              ("spree_assets".viewable_id IN
                ( SELECT "spree_variants".id
                  FROM "spree_variants"
                  WHERE
                  "spree_variants"."product_id" = sp.id AND "spree_variants"."deleted_at" IS NULL
                ) AND "spree_assets".viewable_type = 'Spree::Variant')
            )
          AND
            lower("spree_assets".attachment_file_name) LIKE '%front-crop%'
          LIMIT 1) as product_image

        FROM "spree_orders" o
        LEFT OUTER JOIN "spree_line_items" li ON li."order_id" = o."id"
        LEFT OUTER JOIN "line_item_personalizations" lip ON lip."line_item_id" = li."id"
        LEFT OUTER JOIN "spree_variants" sv ON sv."id" = li."variant_id"
        LEFT OUTER JOIN "spree_products" sp ON sp."id" = sv."product_id"
        INNER JOIN "spree_addresses" sa ON sa."id" = o."bill_address_id"
        INNER JOIN "spree_addresses" ssa ON ssa."id" = o."ship_address_id"
        INNER JOIN "spree_states" ssa_s ON ssa_s."id" = ssa."state_id"
        INNER JOIN "spree_countries" ssa_c ON ssa_c."id" = ssa."country_id"
        INNER JOIN "fabrications" f ON f."line_item_id" = li."id"
        INNER JOIN "factories" fa ON sp."factory_id" = fa."id"
        INNER JOIN "spree_shipments" ss ON ss."order_id" = o."id",

        LATERAL( SELECT
          CASE WHEN lip.id > 0
          THEN (SELECT sovv.variant_id FROM "spree_option_values" sov
            INNER JOIN "spree_option_values_variants" sovv ON "sov"."id" = sovv."option_value_id"
            WHERE
              sovv.variant_id IN (SELECT "spree_variants".id FROM "spree_variants"
                WHERE "spree_variants".product_id = sp.id AND "spree_variants"."is_master" = 'f' AND "spree_variants"."deleted_at" IS NULL)
              AND sov.id = lip.color_id
              LIMIT 1)
          ELSE NULL
          END as custom_variant_id) s1

        WHERE completed_at IS NOT NULL
          AND o.completed_at between '#{from}' and '#{to}'
        ORDER BY completed_at;
      SQL
    end

  end
end
