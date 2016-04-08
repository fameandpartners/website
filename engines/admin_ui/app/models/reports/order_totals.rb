module Reports
  class OrderTotals
    include RawSqlCsvReport

    def description
      'OrderTotals'
    end

    def to_sql
      <<-SQL
        SELECT
          number,
          o.id,
          item_total,
          lic.items,
          total,
          payment_total,
          email,
          completed_at :: DATE,
          m.utm_medium,
          m.utm_source,
          m.utm_campaign
        FROM spree_orders o LEFT JOIN (SELECT
                                         order_id,
                                         count(*) AS items
                                       FROM spree_line_items
                                       GROUP BY order_id) lic ON lic.order_id = o.id
          LEFT JOIN marketing_order_traffic_parameters m ON m.order_id = o.id
        WHERE completed_at IS NOT NULL
        ORDER BY completed_at;
      SQL
    end

  end
end
