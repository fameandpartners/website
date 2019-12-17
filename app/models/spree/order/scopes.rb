module Spree
  class Order
    module Scopes
      def completed
        self.where(arel_table[:completed_at].not_eq(nil))
      end
      def valid_orders
        self.where("item_total > 0")
      end
      def shipment_states
        # This is literally 1000 times faster than `uniq.pluck(:shipment_state)`
        # See https://wiki.postgresql.org/wiki/Loose_indexscan
        qry = <<-SQL
          WITH RECURSIVE t AS (
               SELECT min(shipment_state) AS shipment_state FROM spree_orders
               UNION ALL
               SELECT (SELECT min(shipment_state) FROM spree_orders WHERE shipment_state > t.shipment_state)
               FROM t WHERE t.shipment_state IS NOT NULL
               )
            SELECT shipment_state FROM t WHERE shipment_state IS NOT NULL
        SQL
        find_by_sql(qry).collect(&:shipment_state)
      end

    end
  end
end
