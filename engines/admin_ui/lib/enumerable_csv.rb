require 'csv'

# Define an each method which yields single items to the caller
# Allows streaming data by lazy evaluation of the `to_csv_rows` method
# e.g.
# def each
#   return to_enum(__callee__) unless block_given?
#
#   report_query.find_each do |item|
#     yield item.to_hash
#   end
# end
module EnumerableCSV
  def self.included(other)
    other.send :include, Enumerable
  end

  def report
    to_csv_rows.each do |row|
      puts row
    end
  end

  def to_csv_rows
    return to_enum(__callee__) unless block_given?

    each_with_index do |report_row, idx|
      data = report_row.to_h

      if idx.zero?
        yield CSV::Row.new(data.keys, data.keys, true)
      end

      yield CSV::Row.new(data.keys, data.values)
    end
  end
end
