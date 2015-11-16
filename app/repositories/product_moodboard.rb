class Repositories::ProductMoodboard
  include Repositories::CachingSystem

  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read
    OpenStruct.new({
      song_item:        convert_item(song_item),
      celebrity_item:   convert_item(celebrity_item),
      items:            other_items
    })
  end

  # cache_results :read

  private

  def convert_item(item)
    OpenStruct.new(image_url: item.try(:image).try(:url), source: item.try(:source))
  end

  def inspirations
    @inspirations ||= product.inspirations.active.to_a
  end

  def song_item
    @song_item ||= inspirations.detect{|item| item.item_type == 'song' }
  end

  def celebrity_item
    @celebrity_item ||= inspirations.detect{ |item| item.image_file_name.downcase.include?('celeb') if item.image_file_name }
  end

  def other_items
    items = inspirations.select{|item| item.item_type != 'parfume' && item.item_type != 'song' && !item.image_file_name.downcase.include?('celeb') }
    @other_items ||= items.take(4).collect{ |item| convert_item(item) }
  end

  def cache_key
    "product-moodboad-#{ product.permalink }"
  end
end
