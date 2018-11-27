require 'business_time'
require_relative 'delivery_policy'

module Policies
  class LineItemDeliveryPolicy
    include DeliveryPolicy

    def initialize(line_item)
      @line_item = line_item
      @product = @line_item.product

      @making_option = @line_item.making_options.first&.product_making_option&.making_option
      @making_option ||= @product.making_options.active.where(default: true).first&.making_option
    end

    def ship_by_date
      ship_by_date_for_making_option(@line_item.order.completed_at || Time.now, @making_option)
    end

    def code
      @making_option.code
    end

    def delivery_date
      # line_item.stock.nil? ? product.delivery_period :  '5 - 7 business days'

      delivery_date_for_making_option(@line_item.order.completed_at || Time.now, @making_option)
    end

    def delivery_period
      # line_item.stock.nil? ? product.delivery_period :  '5 - 7 business days'

      display_period_for_making_option(@making_option)
    end
  end
end
