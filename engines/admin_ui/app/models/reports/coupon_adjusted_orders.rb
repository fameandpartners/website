module Reports
  class CouponAdjustedOrders
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
      'CouponAdjustedOrders'
    end

    def to_sql
      <<-SQL
        SELECT
          array_to_string(array_agg(pc.code),', ') as coupon_codes,
          sum(a.amount) total_coupon_value,
          o.adjustment_total as total_applied_adjustments,
          o.*
        FROM spree_orders o
          JOIN spree_adjustments a ON a.source_id = o.id AND a.source_type = 'Spree::Order' AND
                                      a.originator_type = 'Spree::PromotionAction'
          JOIN spree_promotion_actions pa ON a.originator_id = pa.id
          JOIN spree_activators pc ON pa.activator_id = pc.id
        WHERE
          o.completed_at IS NOT NULL
        AND o.completed_at between '#{from}' and '#{to}'
        GROUP BY o.id
        ORDER BY o.completed_at DESC
      SQL
    end
  end
end
