# Usage:
#   @discount ||= Repositories::Discount.read(self.class, self.id)
#   @discounts ||= Repositories::Discount.read_all(self.class, [])
#
# shortcuts
#   @discount ||= Repositories::Discount.get_product_discount(product.id)
#
# tools
#    Repositories::Discount.expire_cache!(true) # reset cache
#    Repositories::Discount.discounts(force: true) # reset & load
module Repositories; end
class Repositories::Discount
  # available discountable_type
  #   Spree::Product
  #   ..

  class << self
    def get_product_discount(product_id)
      read("Spree::Product", product_id)
    end

    def read(discountable_class, discountable_id)
      key = type_to_key(discountable_class)
      discounts[key] ||= {}
      discounts[key][discountable_id].try(:clone)
    end

    def read_all
      key = type_to_key(discountable_class)
      Array.wrap(discountable_ids).map do |discountable_id|
        discount = read(discountable_class, discountable_id)
        if discount
          discount.discountable_id = discountable_id
          discount.discountable_class = discountable_class
          discount
        else
          nil
        end
      end
    end

    def discounts(options = {})
      expire_cache!(options[:force])
      @discounts ||= Rails.cache.fetch(cache_key, expires_in: cache_expires_in) { load_all_discounts }
    end

    def expire_cache!(force = false)
      if force
        @discounts = nil
        Rails.cache.delete(cache_key)
      elsif @discounts_loaded_at.blank? || @discounts_loaded_at < class_variables_expires_in.seconds.ago
        @discounts_loaded_at = nil
      end
    end

    private

      # structure like this:
      # {
      #   spree_products: {
      #     id: OpenStruct.new(amount: amount)
      #   }
      #
      # }
      def load_all_discounts
        all_discounts = Hash.new()

        discounts_scope.group_by(&:discountable_type).each do |discountable_class, discounts|
          key = type_to_key(discountable_class)
          all_discounts[key] ||= {}

          discounts.each do |discount|
            existing_discount = all_discounts[key][discount.discountable_id]
            if existing_discount.present? && (existing_discount.amount > discount.amount)
              # we already have saved better discount
            else
              all_discounts[key][discount.discountable_id] = OpenStruct.new(
                amount: discount.amount,
                size: discount.size
              )
            end
          end
        end
        all_discounts
      end

      def discounts_scope
        ::Discount.includes(:sale).
          where(sale_id: active_sales_ids).
          where("amount is not null and amount > 0")
      end

      def active_sales_ids
        Spree::Sale.active_sales_ids
      end

      def search_scope(options = {})
        ::Discount.where(options).where("amount is not null and amount > 0").order('amount desc')
      end

      def type_to_key(discountable_type)
        discountable_type.to_s.parameterize.underscore.to_sym
      end

      def cache_key
        'application-sale-discounts'
      end

      def cache_expires_in
        configatron.cache.expire.long
      end

      # we don't have any mechanism to reset class variables through all instances
      # keep this value small - single request to redis per request works too
      def class_variables_expires_in
        configatron.cache.expire.quickly
      end
  end
end
