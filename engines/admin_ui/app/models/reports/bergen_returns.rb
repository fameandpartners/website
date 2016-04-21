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
      report_query.find_each(batch_size: 50) do |return_item|
        yield BergenReturnsPresenter.new(return_item)
      end
    end

    def report_query
      ReturnRequestItem.
        includes({
                   order_return_request: { order: :shipping_method },
                   line_item:            [:variant, { personalization: [:size, :color] }]
                 }).
        where('created_at BETWEEN ? AND ?', @from, @to)
    end

    class BergenReturnsPresenter < SimpleDelegator
      attr_reader :return_item

      def initialize(return_item)
        @return_item = return_item
      end

      private def global_sku
        GlobalSku.find_or_create_by_line_item(line_item_presenter: return_item.line_item_presenter)
      end

      def company_name
        'Fame and Partners'.freeze
      end

      def state
        'Not Required'
      end

      def carrier
        return_item.order.shipping_method.name
      end

      def warehouse
        'BERGEN LOGISTICS NJ'.freeze
      end

      def shipment_type_list
        'Open to Hang'.freeze
      end

      def style
        global_sku.style_number
      end

      def color
        global_sku.color_name
      end

      def size
        global_sku.size
      end

      # Expected item quantity
      def expected
        return_item.quantity
      end

      def upc
        global_sku.upc
      end

      def to_h
        {
          carrier:            carrier,
          color:              color,
          company_name:       company_name,
          expected:           expected,
          shipment_type_list: shipment_type_list,
          size:               size,
          state:              state,
          style:              style,
          upc:                upc,
          warehouse:          warehouse,
        }
      end
    end
  end
end
