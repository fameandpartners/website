require 'admin_ui/engine'

module Bergen
  module Presenters
    class ItemReturnPresenter
      extend Forwardable

      attr_accessor :item_return

      def_delegators :item_return,
                     :order_number,
                     :bergen_asn_number

      def initialize(item_return:)
        @item_return = item_return
      end

      def rejected?
        item_return.bergen_damaged_quantity > 0
      end

      def accepted?
        !rejected? && item_return.bergen_actual_quantity > 0
      end

      def admin_ui_mail_url
        AdminUi::Engine.routes.url_helpers.item_return_url(item_return, default_url_options)
      end

      private

      def default_url_options
        FameAndPartners::Application.config.action_mailer.default_url_options
      end
    end
  end
end
