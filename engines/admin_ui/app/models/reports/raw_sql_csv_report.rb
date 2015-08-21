require 'enumerable_csv'

module Reports
  module RawSqlCsvReport
    def self.included(other)
      other.send :include, EnumerableCSV
    end

    def description
      self.class.name
    end

    def to_sql
      raise NotImplementedError
    end

    def each
      return to_enum(__callee__) unless block_given?

      report_query.each do |row|
        yield row
      end
    end

    def report_query
      ActiveRecord::Base.connection.execute(to_sql)
    end
  end
end
