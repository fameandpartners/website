module Reports
  class ProductNumbers
    include RawSqlCsvReport

    def description
      'ProductNumbers'
    end

    def to_sql
      <<-SQL
        SELECT * FROM global_skus;
      SQL
    end
  end
end
