module WeddingAtelier
  class OrderSerializer < ::CartSerializer

    def item_count
      object.line_items.for_wedding_atelier.size
    end

    def line_items
      object.line_items.for_wedding_atelier.collect do |line_item|
        LineItemSerializer.new(line_item)
      end
    end
  end
end

