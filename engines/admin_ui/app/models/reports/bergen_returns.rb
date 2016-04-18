require 'delegate'
require 'enumerable_csv'

module Reports
  class BergenReturns
    include EnumerableCSV

    attr_accessor :from, :to

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    end

    def description
      'Bergen Returns (pick ticket creation from returned orders)'
    end

    def each
      to_enum(__callee__) unless block_given?
    end
  end
end
