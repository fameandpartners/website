class Products::ProductMoodboardResource
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read
    OpenStruct.new({
      song_items: song_items,
      parfume_items: parfume_items,
      items: other_items
    })
  end

  private

  def convert_item(item)
    OpenStruct.new(image_url: item.image.url, source: item.source)
  end

  def moodboard_items
    @moodboard_items ||= product.moodboard_items.active.to_a
  end

  def song_items
    @song_items ||= moodboard_items.select{|item| item.item_type == 'song' }.map{|item| convert_item(item)}
  end

  def parfume_items
    @parfume_items ||= moodboard_items.select{|item| item.item_type == 'parfume' }.map{|item| convert_item(item)}
  end

  def other_items
    @other_items ||= begin
      limit = 6 - (song_items.size + parfume_items.size )
      limit = 0 if limit <= 0
      items = moodboard_items.select{|item| item.item_type != 'parfume' && item.item_type != 'song' }[0...limit]
      items.map{|item| convert_item(item)}
    end
  end
end
