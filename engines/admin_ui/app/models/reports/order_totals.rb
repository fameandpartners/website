module Reports
  class OrderTotals
    include RawSqlCsvReport

    def description
      'OrderTotals'
    end

    def to_sql
      <<-SQL
        WITH order_taxes AS (
            SELECT ord.id order_id, adj.amount amount
            FROM spree_adjustments adj
              LEFT JOIN spree_orders ord ON adj.adjustable_id = ord.id
            WHERE
              adj.adjustable_type = 'Spree::Order'
              AND adj.originator_type = 'Spree::TaxRate'
        ), order_items AS (
            SELECT order_id, count(*) AS items
            FROM spree_line_items
            GROUP BY order_id
        )

        SELECT
          number,
          o.id,
          item_total,
          lic.items,
          total,
          payment_total,
          tax.amount tax_total,
          o.email,
          completed_at :: DATE,
          m.utm_medium,
          m.utm_source,
          m.utm_campaign,
          o.user_first_name,
          o.user_last_name,
          shipping_address.firstname AS "shipping_address_first_name",
          shipping_address.lastname AS "shipping_address_last_name",
          shipping_address.address1 AS "shipping_address_address1",
          shipping_address.address2 AS "shipping_address_address2",
          shipping_address.city AS "shipping_address_city",
          shipping_address.zipcode AS "shipping_address_zipcode",
          shipping_address.phone AS "shipping_address_phone",
          shipping_address_state.name AS "shipping_address_state",
          shipping_address_country.name AS "shipping_address_country",
          billing_address.firstname AS "billing_address_first_name",
          billing_address.lastname AS "billing_address_last_name",
          billing_address.address1 AS "billing_address_address1",
          billing_address.address2 AS "billing_address_address2",
          billing_address.city AS "billing_address_city",
          billing_address.zipcode AS "billing_address_zipcode",
          billing_address.phone AS "billing_address_phone",
          billing_address_state.name AS "billing_address_state",
          billing_address_country.name AS "billing_address_country"

        FROM spree_orders o
          LEFT JOIN order_items lic ON lic.order_id = o.id
          LEFT JOIN order_taxes tax ON tax.order_id = o.id
          LEFT JOIN marketing_order_traffic_parameters m ON m.order_id = o.id
          LEFT JOIN spree_addresses shipping_address ON shipping_address.id = o.ship_address_id
          LEFT JOIN spree_addresses billing_address ON billing_address.id = o.bill_address_id
          LEFT JOIN spree_states shipping_address_state ON shipping_address_state.id = shipping_address.state_id
          LEFT JOIN spree_states billing_address_state ON billing_address_state.id = billing_address.state_id
          LEFT JOIN spree_countries shipping_address_country ON shipping_address_country.id = shipping_address.country_id
          LEFT JOIN spree_countries billing_address_country ON billing_address_country.id = billing_address.country_id
        WHERE completed_at IS NOT NULL
        ORDER BY completed_at;
      SQL
    end
  end
end
