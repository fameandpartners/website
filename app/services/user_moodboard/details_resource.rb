# resource to show detailed products & etc
# moodboard products page
#
# usage:
#   UserMoodboard::DetailsResource.new(user: user).read
#
# note: not finished
module UserMoodboard; end

class UserMoodboard::DetailsResource
  attr_reader :site_version, :user

  def initialize(options = {})
    @user           = options[:user]
    @site_version   = options[:site_version] || SiteVersion.default
  end

  def read
    ::UserMoodboard::DetailsPresenter.new(
      item_count: wishlist_items.size,
      items: wishlist_items
    )
  end

  private

    def wishlist_items
      @wishlist_items ||= Repositories::UserWishlistItems.new(user: user).read_all
    end
end
