require 'enumerable_csv'

module Reports
  class SaleItems
    include EnumerableCSV

    def initialize(from: from_date, to: to_date)
      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    rescue NoMethodError => e
      raise e
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


    def each
      return to_enum(__callee__) unless block_given?

      report_query.each do |row|
        yield row
      end
    end

    private

    def report_query
      ActiveRecord::Base.connection.execute(to_sql)
    end

    def to_sql
      <<-SQL
        select
          li.price                  as sale_price,
          li.old_price              as original_price,
          (li.old_price - li.price) as discount,
          v.product_id              as product_id,
          mv.sku                    as sku,
          o.number                  as order_number,
          o.completed_at::date      as order_date,
          li.id                     as line_item_id
        from spree_line_items li
          join spree_orders o    on o.id = li.order_id
          join spree_variants v  on v.id = li.variant_id
          join spree_variants mv on mv.product_id = v.product_id and mv.is_master = true
        where
          old_price is not null
        and
          o.completed_at is not null
        and
          o.completed_at between '#{from}' and '#{to}'
      SQL
    end


    # o.completed_at between '2015-02-01 00:00:00.000000' and '2015-05-31 23:59:59.999999'
  end
end
