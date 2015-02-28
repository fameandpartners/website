module UserMoodboard; end
class UserMoodboard::BasePresenter < OpenStruct
  def serialize
    { 
      item_count: item_count,
      items: items.map{|item| item.marshal_dump }
    }
  end

  def include?(options = {})
    return false if options.blank?
  end
end
