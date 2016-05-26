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
      Spree::Order::FastOrder.get_sql report: :daily_orders, from_date: from, to_date: to
    end

  end
end
