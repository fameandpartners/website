require 'tempfile'
require 'csv'

module NextLogistics
  module FTP
    class Receipt
      RECEIPT_HEADERS = %w(ProductCode PO_Reference Description OtherDescription Reference2 Quantity)

      attr_reader :process, :buffer

      def initialize(return_request_process:)
        @process = return_request_process
        @buffer  = Tempfile.new('next-receipt')
      end

      def tempfile
        CSV.open(buffer, 'w', headers: RECEIPT_HEADERS) do |csv|
          items_for_return.each do |rri|
            formatter = RowFormatter.new(return_request_item: rri)
            csv << formatter.to_row
          end
        end
        buffer
      end

      private def items_for_return
        process.order_return_request.return_request_items.select { |rri|
          rri.return_or_exchange?
        }
      end

      class RowFormatter
        def initialize(return_request_item:)
          # TODO
        end

        # UPC
        def product_code
          '12345'
        end

        # Spree Order Number
        def po_reference
          'R123123123'
        end

        # [product_name, size, color_name].join(' - ')
        def description
          'Super Dress - US10/AU14 - Red'
        end

        # Style Number, AKA, SKU
        def other_description
          'BE1123'
        end

        # Customer Full name
        def reference2
          'Loroteiro Silvestre'
        end

        # For now, it's always one
        def quantity
          1
        end

        def to_row
          [
            product_code,
            po_reference,
            description,
            other_description,
            reference2,
            quantity
          ]
        end
      end
    end
  end
end
