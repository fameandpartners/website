# description:
#   sort products { id, color } by following rules:
#     - don't place same product near,
#     - each row should have set of different colors
#
# usage:
#   result = Products::ProductsSorter.new(products: []).sorted_products
#
# note

module Products; end
class Products::ProductsSorter
  attr_reader :products, :row_size

  def initialize(options = {})
    @products    = options[:products].dup
    @row_size    = options[:row_size].present? ? options[:row_size].to_i : 4
    @style       = options[:style]
    @offset      = options[:offset].to_i
    @color_group = options[:color_group]
    @body_shapes = options[:body_shapes]
    @order       = options[:order]
    init_featured_products_list
  end

  def sorted_products
    @sorted_products ||= begin
      sort!
      if @color_group.blank? && @body_shapes.blank? && @order.blank?
        if @style.present? && @style_featured_products_list[@style.name].present?
          sort_featured_products! if @offset == 0
          remove_dup_featured_products! if @offset > 0
        end
      end
      products
    end
  end

  private

    def init_featured_products_list
      @style_featured_products_list = {}
      @style_featured_products_list["Plus Size"] = [{name:'Harper',            color_presentation: 'Blue Azalea Floral'},
                                                    {name:'Marta',             color_presentation: 'Vibrant Purple'},
                                                    {name:'Fiona Two Piece',   color_presentation: 'Black and Gold'},
                                                    {name:'Lynette',           color_presentation: 'Black'},
                                                    {name:'Gathered Angel',    color_presentation: 'Berry'}
                                                   ]

    end

    def sort_featured_products!
      list = @style_featured_products_list[@style.name]
      for p in list.reverse do
        products.count.times do |index|
          if products[index].name == p[:name] && products[index].color.presentation == p[:color_presentation]
            item = products[index]
            products.delete_at(index)
            products.prepend(item)
            break
          end
        end
      end
    end

    def remove_dup_featured_products!
      list = @style_featured_products_list[@style.name]
      for p in list.reverse do
        products.count.times do |index|
          if products[index].name == p[:name] && products[index].color.presentation == p[:color_presentation]
            item = products[index]
            products.delete_at(index)
            break
          end
        end
      end
    end

    def sort!
      products.count.times do |index|
        (products.count - index).times do |position|
          inspected = products[index + position]

          if !is_same_product_in_above_or_left?(index, inspected) &&
             !is_more_then_one_item_in_row_with_same_color?(index, inspected)
            products.insert(index, products.delete_at(index + position))
            break
          end
        end
      end
    end

    def is_same_product_in_above_or_left?(index, target)
      left  = index > 0 ? products[index - 1] : nil
      above = index >= row_size ? products[index - row_size] : nil

      scope = [left, above].compact

      scope.any? do |item|
        item.id == target.id
      end
    end

    def is_more_then_one_item_in_row_with_same_color?(index, target)
      position_in_row = index % row_size

      return false if position_in_row.eql?(0)

      scope = products.to(index - 1).from(index - position_in_row)

      scope.select do |item|
        item.color == target.color
      end.count > 1
    end
end
