module Spree
  class Order
    module Scopes
      def completed
        self.where(arel_table[:completed_at].not_eq(nil))
      end
    end
  end
end
