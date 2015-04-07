# load short moodboard data, to use on collection/products/etc pages
#
# usage:
#   UserMoodboard::BaseResource.new(user: user).read
#
require File.join(Rails.root, 'app/presenters/user_moodboard/base_presenter.rb')

module UserMoodboard; end
class UserMoodboard::BaseResource
  attr_reader :site_version, :user

  def initialize(options = {})
    @user           = options[:user]
  end

  def read
    # guest user have no moodboard
    if user.blank?
      ::UserMoodboard::BasePresenter.new(
        item_count: 0,
        items: []
      )
    else
      ::UserMoodboard::BasePresenter.new(
        item_count: wishlist_items.size,
        items: wishlist_items
      )
    end
  end

  private

    def wishlist_items
      @wishlist_items ||= begin
        user.wishlist_items.map do |item|
          FastOpenStruct.new(
            variant_id: item.spree_variant_id,
            product_id: item.spree_product_id,
            color_id: item.product_color_id
          )
        end
      end
    end
end
