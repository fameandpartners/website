module Reports
  class BodyShapeCalculatorResults
    include RawSqlCsvReport

    attr_reader :from, :to

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    end

    def description
      'Body Shape Calculator Results'
    end

    def to_sql
      <<-SQL
        SELECT *
        FROM marketing_body_calculator_measures mm
        WHERE mm.created_at between '#{from}' and '#{to}'
        ORDER BY mm.created_at DESC
      SQL
    end
  end
end
