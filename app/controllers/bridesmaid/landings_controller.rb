class Bridesmaid::LandingsController < Bridesmaid::BaseController
  def bride
    set_page_titles
  end

  def bridesmaid
    set_page_titles

    user   = Spree::User.find_by_slug!(params[:user_slug])
    event  = BridesmaidParty::Event.find_by_spree_user_id!(user.id)

    if spree_user_signed_in? && params[:token].blank?
      if current_spree_user.id == user.id
        redirect_to bridesmaid_party_path
      elsif !event.members.map(&:spree_user_id).include?(current_spree_user.id)
        raise Bridesmaid::Errors::MoodboardAccessDenied
      end
    elsif params[:token].present?
      member = event.members.find_by_token(params[:token])

      if member.blank?
        raise Bridesmaid::Errors::MoodboardAccessDenied
      end
    else
      raise Bridesmaid::Errors::MoodboardAccessDenied
    end

    @bride = user
  end
end
