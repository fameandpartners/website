module Reports
  class SaleItems
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
      'ItemsSoldOnSale'
    end

    def to_sql
      <<-SQL
        select
          li.price                  as sale_price,
          li.old_price              as original_price,
          (li.old_price - li.price) as discount,
          o.currency                as currency,
          v.product_id              as product_id,
          p.name                    as product_name,
          mv.sku                    as sku,
          o.number                  as order_number,
          o.completed_at::date      as order_date,
          li.id                     as line_item_id
        from spree_line_items li
          join spree_orders o    on o.id = li.order_id
          join spree_variants v  on v.id = li.variant_id
          join spree_variants mv on mv.product_id = v.product_id and mv.is_master = true
          join spree_products p  on p.id          = v.product_id
        where
          old_price is not null
        and
          o.completed_at is not null
        and
          o.completed_at between '#{from}' and '#{to}'
      SQL
    end
  end
end
