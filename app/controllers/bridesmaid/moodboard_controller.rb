# public_moodboard_path
# wishlist
class Bridesmaid::MoodboardController < Bridesmaid::BaseController

  def show
    load_owner!
    check_availability!

    @moodboard = moodboard_resource.read

    set_page_titles(title: @moodboard.title)
  end

  def destroy_item
    raise 'here'
  end

  private

    def moodboard_resource
      Bridesmaid::Moodboard.new(
        site_version: current_site_version,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner
      )
    end

    # generate some hash and share through it?
    def moodboard_owner
      Spree::User.where(slug: params[:user_slug]).first || current_spree_user
    end

    def load_owner!
      raise Bridesmaid::Errors::MoodboardOwnerNotFound if moodboard_owner.blank?
    end

    # check user access
    def check_availability!
      return true if moodboard_owner.id == current_spree_user.id
      return true if moodboard_owner.bridesmaid_user_profile.present?

      raise Bridesmaid::Errors::MoodboardAccessDenied
    end
end
