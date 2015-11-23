class MoodboardPresenter
  attr_reader :moodboard
  def initialize(user)
    if user
      @moodboard = user.moodboards.default_or_create
    end
  end

  def items
    @items ||= begin
      if moodboard.present?
        moodboard.items.active.map do |item|
          {
            variant_id: item.variant_id,
            product_id: item.product_id,
            color_id:   item.color_id
          }
        end
      else
        []
      end
    end
  end

  def as_json(*_opts)
    {
      item_count: items.count,
      items: items
    }
  end

  # TODO - Migrated from old `UserMoodboard::BasePresenter` refactor
  def contains(product_id: , color_id: nil)
    # TODO Is that even required?
    return false unless product_id.present?

    if color_id
      items.any?{|item| item[:product_id] == product_id.to_i && item[:color_id] == color_id.to_i }
    else
      items.any?{|item| item[:product_id] == product_id.to_i }
    end
  end
end
