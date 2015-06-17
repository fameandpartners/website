module Spree
  module Admin
    class ModalsController < BaseController

      def index
      end

      helper_method :promo_codes

      def promo_codes
        @promo_codes ||= Spree::Promotion.where('usage_limit > 1 or usage_limit is null').
          where('starts_at <= ? and expires_at >= ?', Date.current, Date.current).
          collect { |x| [x.code, "#{x.code} - #{x.description}"] }
      end
    end
  end
end
