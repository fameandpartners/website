# Note that this class *used* to be called MoodboardItem,
# which conflicted with the name we wanted for child objects of Moodboards (MoodboardItem)
# This objects values are more properly the "inspirations" for a product, so are now named Inspiration
# They include the following,
#  - "moodboard" images
#  - songs
#  - perfumes
# Also related are CelebrityInspiration

class Inspiration < ActiveRecord::Base
  attr_accessible :spree_product_id, :image, :item_type, :content, :active, :name, :title

  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id, inverse_of: :inspirations

  has_attached_file :image,
    styles: { product: "375x480#", thumbnail: "187x240#" },
    default_style: :product,
    default_url:   :default_image_for_item_type

  default_scope order: 'position asc'

  scope :active, where(active: true)

  ITEM_TYPES = %w{ moodboard song parfume }
  ITEM_TYPES.each do |scope_name|
    scope scope_name.to_sym, where(item_type: scope_name.to_s)
  end

  validates :item_type, inclusion: ITEM_TYPES, presence: true

  # in a magic day, far far away, this will be moved to decorator
  def default_image_for_item_type
    case item_type.to_s
    when 'parfume'
      '/assets/_sample/category-grey-1.jpg'
    when 'song'
      '/assets/_sample/category-grey-2.jpg'
    else
      '/assets/_sample/category-grey-3.jpg'
    end
  end

  def source
    self.content || self.default_source
  end

  def default_source
    case item_type.to_s
    when 'parfume'
      'http://fameandpartners.com'
    when 'song'
      'https://soundcloud.com/pedro-noe/game-of-thrones-main-title'
    else
      ''
    end
  end
end
