class Bridesmaid::MoodboardController < Bridesmaid::BaseController
  def show
    load_moodboard_owner!
    check_moodboard_state!

    if current_spree_user.present?
      apply_stored_user_references(current_spree_user)

      if user_has_access?(current_spree_user)
        # if user just signed in
        if session[:show_successfull_login_popup].present?
          session.delete(:show_successfull_login_popup)
          @show_successfull_signup = true
        end
        # default case
      else
        raise Bridesmaid::Errors::MoodboardAccessDenied
      end
    else
      if party_membership_invite.present?
        # show moodboard with popup
        store_user_reference(party_membership_invite) 
        @show_login_popup = true
      else
        raise Bridesmaid::Errors::MoodboardAccessDenied
      end
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

    def check_moodboard_state!
      if event.blank? || !event.completed?
        raise Bridesmaid::Errors::MoodboardNotReady
      end
    end

    def party_membership_invite
      return @party_membership_invite if instance_variable_defined?("@party_membership_invite")

      if token.present?
        @party_membership_invite = event.members.where(token: token).first
      else
        @party_membership_invite = nil
      end
    end

    def store_user_reference(membership)
      if membership.present?
        session[:bridesmaid_party_membership_id] = membership.id
        session[:bridesmaid_party_event_id]      = membership.event_id
      end
    end

    def apply_stored_user_references(user)
      event_id  = session[:bridesmaid_party_event_id]
      member_id = session[:bridesmaid_party_membership_id]

      return if event_id.blank? || member_id.blank?

      membership = BridesmaidParty::Member.where(event_id: event_id, id: member_id).first
      if membership.present?
        membership.spree_user_id = user.id
        membership.save
        session.delete(:bridesmaid_party_event_id)
        session.delete(:bridesmaid_party_membership_id)
      end
    end

    def user_has_access?(user)
      event.spree_user_id == user.id || event.members.where(spree_user_id: user.id).exists? 
    end

    def moodboard_resource
      Bridesmaid::Moodboard.new(
        site_version: current_site_version,
        accessor: current_spree_user,
        moodboard_owner: moodboard_owner
      )
    end
end
