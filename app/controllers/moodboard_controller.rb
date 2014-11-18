# public_moodboard_path
# wishlist
class MoodboardController < ApplicationController
  module Moodboard; end
  module Moodboard::Errors; end
  class  Moodboard::Errors::OwnerNotFound < StandardError; end
  class  Moodboard::Errors::AccessDenied < StandardError; end

  rescue_from Moodboard::Errors::OwnerNotFound, Moodboard::Errors::AccessDenied do |exception|
    if current_spree_user.present?
      redirect_to wishlist_path
    else
      redirect_to root_path
    end
  end

  def show
    load_owner!
    check_availability!

    @title = "#{ moodboard_owner.full_name }'s mooodboard"

    @moodboard  = OpenStruct.new({
      title: @title,
      items: moodboard_owner.wishlist_items.to_a
    })
  end

  private

    # generate some hash and share through it?
    def moodboard_owner
      Spree::User.where(slug: params[:user_slug]).first
    end

    def load_owner!
      raise Moodboard::Errors::OwnerNotFound if moodboard_owner.blank?
    end

    # currently, we need publish wishlist/moodboard page only for users
    # who came from bridesmaid party
    def check_availability!
      return true if moodboard_owner.id == current_spree_user.id
      return true if moodboard_owner.bridesmaid_user_profile.present?

      raise Moodboard::Errors::AccessDenied
    end
end
