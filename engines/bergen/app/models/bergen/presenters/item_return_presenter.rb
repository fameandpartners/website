require 'admin_ui/engine'

module Bergen
  module Presenters
    class ItemReturnPresenter
      extend Forwardable

      attr_reader :item_return

      def_delegators :item_return,
                     :order_number,
                     :bergen_asn_number,
                     :product_name,
                     :product_style_number,
                     :product_size,
                     :product_colour

      def initialize(item_return:)
        @item_return = item_return.reload
      end

      def rejected?
        item_return.bergen_damaged_quantity > 0
      end

      def accepted?
        !rejected? && item_return.bergen_actual_quantity > 0
      end

      def order_date
          order.completed_at
      end

      def price
        money = Money.new(item_return.item_price_adjusted, item_return.order_paid_currency)
        money.format
      rescue StandardError => e
        Raven.capture_exception(e)

        item_return.item_price_adjusted
      end

      def customer_address
        order.shipping_address.to_s
      end

      def height
        global_sku.height_value
      end

      def global_upc
        global_sku.upc
      end

      def customization
        global_sku.customisation_name
      end

      def admin_ui_mail_url
        AdminUi::Engine.routes.url_helpers.item_return_url(item_return, default_url_options)
      end

      private

      def default_url_options
        FameAndPartners::Application.config.action_mailer.default_url_options
      end

      def line_item
        item_return.line_item
      end

      def order
        line_item.order
      end

      def global_sku
        line_item_presenter = Orders::LineItemPresenter.new(line_item, order)
        GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
      end
    end
  end
end
