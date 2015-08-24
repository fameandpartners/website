require 'enumerable_csv'

# Wraps common behaviour for SQL based reports
# and allows the report to be downloadable and
# stream-able from admin report controllers.
#
# Usage
# Implement the `to_sql` method.
#
# Automatically includes the EnumerableCSV module
# for easy CSV conversion.
module Reports
  module RawSqlCsvReport
    def self.included(other)
      other.send :include, EnumerableCSV
    end

    # Override
    def description
      self.class.name
    end

    # Implement
    #
    # e.g.
    #   def to_sql
    #     <<-SQL
    #       SELECT * FROM cool_table WHERE raw_sql = super_powerful
    #     SQL
    #   end
    def to_sql
      raise NotImplementedError
    end

    # Allows potentially lazy enumeration
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
