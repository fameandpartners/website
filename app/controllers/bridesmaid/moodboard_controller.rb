# public_moodboard_path
# wishlist
class Bridesmaid::MoodboardController < Bridesmaid::BaseController
  def show
    load_moodboard_owner!
    check_availability!

    if party_membership_invite.present?
      store_user_reference(party_membership_invite) 
      @show_login_popup = true
    elsif current_spree_user.present? && session[:show_successfull_login_popup].present?
      session.delete(:show_successfull_login_popup)
      @show_successfull_signup = true
    end

    @moodboard = moodboard_resource.read

    set_page_titles(title: @moodboard.title)
    show_bridesmaid_header unless @moodboard.is_owner
  end

  private
    
    def event
      @event ||= moodboard_owner.bridesmaid_party_events.first
    end

    def token
      params[:token]
    end

    def party_membership_invite
      return @party_membership_invite if instance_variable_defined?("@party_membership_invite")

      if token.present?
        @party_membership_invite = event.members.where(token: token).first
      else
        @party_membership_invite = nil
      end
    end

    def check_availability!
      if event.blank? || !event.completed?
        raise Bridesmaid::Errors::MoodboardNotReady
      end

      if !user_can_view?(current_spree_user, event, params[:token])
        raise Bridesmaid::Errors::MoodboardAccessDenied
      end
    end

    def store_user_reference(membership)
      if membership.present?
        session[:bridesmaid_party_membership_id] = membership.id
        session[:bridesmaid_party_event_id]      = membership.event_id
      end
    end

    def user_can_view?(user, event, token)
      if user.blank?
        party_membership_invite.present?
      else
        event.spree_user_id == user.try(:id) || event.members.where(spree_user_id: user.try(:id)).exists? || party_membership_invite.present?
      end
    end

    def moodboard_resource
      Bridesmaid::Moodboard.new(
        site_version: current_site_version,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner
      )
    end
end
