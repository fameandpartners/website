module Products
  class ColorVariantsSorter
    def initialize(objects)
      @objects = objects.dup
    end

    def sort!
      @objects.count.times do |index|
        (@objects.count - index).times do |position|
          inspected = @objects[index + position]

          if !is_same_product_in_above_or_left?(index, inspected) &&
             !is_more_then_one_item_in_row_with_same_color?(index, inspected)
            @objects.insert(index, @objects.delete_at(index + position))
            break
          end
        end
      end
    end

    def results
      @objects
    end

    private

    def is_same_product_in_above_or_left?(index, target)
      left  = index > 0 ? @objects[index - 1] : nil
      above = index > 3 ? @objects[index - 4] : nil

      scope = [left, above].compact

      scope.any? do |item|
        item.product.id == target.product.id
      end
    end

    def is_more_then_one_item_in_row_with_same_color?(index, target)
      position_in_row = index % 4

      return false if position_in_row.eql?(0)

      scope = @objects.to(index - 1).from(index - position_in_row)

      scope.select do |item|
        item.color.id == target.color.id
      end.count > 1
    end
  end
end