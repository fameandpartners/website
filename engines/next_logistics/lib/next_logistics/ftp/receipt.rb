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
        CSV.open(buffer, 'w', headers: :first_row) do |csv|
          csv << RECEIPT_HEADERS
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
        attr_reader :return_request_item

        def initialize(return_request_item:)
          @return_request_item = return_request_item
        end

        private def order
          return_request_item.order
        end

        private def line_item_presenter
          Orders::LineItemPresenter.new(return_request_item.line_item, order)
        end

        private def global_sku
          GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
        end

        # UPC
        def product_code
          global_sku.upc
        end

        # Spree Order Number
        def po_reference
          order.number
        end

        # [product_name, size, color_name].join(' - ')
        def description
          [
            line_item_presenter.style_name,
            line_item_presenter.size,
            line_item_presenter.colour_name
          ].join(' - ')
        end

        # Style Number, AKA, SKU
        def other_description
          global_sku.style_number
        end

        # Customer Full name
        def reference2
          order.full_name
        end

        def quantity
          line_item_presenter.quantity
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
