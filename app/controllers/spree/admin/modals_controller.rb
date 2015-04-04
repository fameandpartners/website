module Spree
  module Admin
    class ModalsController < BaseController

      def index
      end

      helper_method :promo_codes

      def promo_codes
        @promo_codes ||= Spree::Promotion.where('usage_limit > 1').where('expires_at < ?', Date.current ).collect { |x| [x.code, "#{x.code} - #{x.description}"] }
      end
    end
  end
end
