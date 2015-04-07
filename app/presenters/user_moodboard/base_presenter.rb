module UserMoodboard; end
class UserMoodboard::BasePresenter < FastOpenStruct
  def serialize
    { 
      item_count: item_count,
      items: items.map{|item| item.marshal_dump }
    }
  end

  # { product_id: , color_id: }
  def contains(options = {})
    return false if options.blank?

    if options[:color_id]
      items.any?{|item| item.product_id == options[:product_id].to_i && item.color_id == options[:color_id].to_i }
    else
      items.any?{|item| item.product_id == options[:product_id].to_i }
    end
  end
end
