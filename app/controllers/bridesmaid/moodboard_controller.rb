# public_moodboard_path
# wishlist
class Bridesmaid::MoodboardController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def show
    load_moodboard_owner!
    check_availability!

    @moodboard = moodboard_resource.read

    set_page_titles(title: @moodboard.title)
    show_bridesmaid_header unless @moodboard.is_owner
  end

  def destroy_item
    # not moodboard owner, user can delete only own items
    variant = current_spree_user.wishlist_items.where(spree_variant_id: params[:variant_id]).destroy_all
    respond_to do |format|
      format.json do
        render json: { variant_id: params[:variant_id] }, status: :ok
      end
    end
  end

  private

    def moodboard_resource
      Bridesmaid::Moodboard.new(
        site_version: current_site_version,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner
      )
    end

    # bride shouldn't view this page.
    # instead, we should redirect to own moodboard
    def check_availability!
      event = moodboard_owner.bridesmaid_party_events.first
      if event.blank? || !event.completed?
        raise Bridesmaid::Errors::MoodboardNotReady
      end
      #if moodboard_owner.id == current_spree_user.id
      #  raise Bridesmaid::Errors::MoodboardNotReady
      #end

      #if !bridesmaid_party_event.members.where(
      #  "spree_user_id = ? or email = ?", current_spree_user.id, current_spree_user.email
      #).exists?
      #  raise Bridesmaid::Errors::MoodboardAccessDenied
      #end
    end
end
