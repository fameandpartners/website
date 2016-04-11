module Reports
  class ProductNumbers
    include RawSqlCsvReport

    def description
      'ProductNumbers'
    end

    def to_sql
      <<-SQL
        SELECT gs.id AS UPC, gs.* FROM global_skus AS gs;
      SQL
    end
  end
end
