module Admin
  class BulkOrderUpdate < ActiveRecord::Base
    attr_accessible :user, :filename

    has_many :line_item_updates, :class_name => 'LineItemUpdate', autosave: true

    def self.hydrated
      includes(
        line_item_updates:
          {
            order:     [],
            shipment:  [],
            line_item: [:variant, :fabrication]
          }
      )
    end

    def total_items
      line_item_updates.count
    end

    def item_states
      line_item_updates.group_by(&:state).collect { |key, items|
        [key || 'new', items.count]
      }.to_h.tap { |h| h.default = 0 }
    end

    def deletable?
      ! line_item_updates.any?(&:state)
    end

  end
end
