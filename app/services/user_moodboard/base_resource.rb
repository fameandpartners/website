# load short moodboard data, to use on collection/products/etc pages
#
# usage:
#   UserMoodboard::BaseResource.new(user: user).read
#
module UserMoodboard; end

class UserMoodboard::Moodboard < OpenStruct
  def serialize
    { 
      item_count: item_count,
      items: items.map{|item| item.marshal_dump }
    }
  end
end

class UserMoodboard::BaseResource
  attr_reader :site_version, :user

  def initialize(options = {})
    @user           = options[:user]
  end

  def read
    # guest user have no moodboard
    if user.blank?
      ::UserMoodboard::Moodboard.new(
        item_count: 0,
        items: []
      )
    else
      ::UserMoodboard::Moodboard.new(
        item_count: wishlist_items.size,
        items: wishlist_items
      )
    end
  end

  private

    #def cache_key
    #  "user-moodboard-base-info-#{ user.id }"
    #end

    def wishlist_items
      @wishlist_items ||= begin
        user.wishlist_items.map do |item|
          OpenStruct.new(
            variant_id: item.spree_variant_id,
            product_id: item.spree_product_id,
            color_id: item.product_color_id
          )
        end
      end
    end
end
