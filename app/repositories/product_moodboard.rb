class Repositories::ProductMoodboard
  include Repositories::CachingSystem
  
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read
    OpenStruct.new({
      song_item:        song_item,
      celebrity_item:   celebrity_item,
      items:            other_items
    })
  end

  cache_results :read

  private

  def convert_item(item)    
    OpenStruct.new(image_url: item.image.url, source: item.source)
  end

  def moodboard_items
    @moodboard_items ||= product.moodboard_items.active.to_a
  end

  def song_item
    @song_item ||= convert_item(song_items.first)
  end

  def song_items
    @song_items ||= moodboard_items.select{|item| item.item_type == 'song' }
  end

  def celebrity_item
    @celebrity_item ||= moodboard_items.collect{ |item| item.source.downcase.include?('celeb') }.first
  end

  def other_items
    items = moodboard_items - [celebrity_item]
    limit = 4
    @other_items ||= begin
      items
      items = moodboard_items.select{|item| item.item_type != 'parfume' && item.item_type != 'song' }[0...limit]
      items.map{|item| convert_item(item)}
    end
  end

  def cache_key
    "product-moodboad-#{ product.permalink }"
  end  
end