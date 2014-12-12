class Bridesmaid::LandingsController < Bridesmaid::BaseController
  def bride
    set_page_titles
  end

  def bridesmaid
    if params[:user_slug]
      redirect_to bridesmaid_party_moodboard_path(user_slug: params[:user_slug])
    else
      redirect_to bridesmad_party_path
    end
  end

#  def old_bridesmaid_page
#    set_page_titles
#    show_bridesmaid_header
#
#    user   = Spree::User.find_by_slug(params[:user_slug])
#    raise Bridesmaid::Errors::MoodboardAccessDenied if user.blank?
#
#    event  = BridesmaidParty::Event.find_by_spree_user_id!(user.id)
#    @bride = user
#
#    if spree_user_signed_in?
#      if params[:token].blank?
#        if current_spree_user.id == user.id
#          redirect_to bridesmaid_party_path
#        elsif event.members.map(&:spree_user_id).include?(current_spree_user.id)
#          render :bridesmaid
#        else
#          raise Bridesmaid::Errors::MoodboardAccessDenied
#        end
#      else
#        membership = event.members.find_by_token!(params[:token])
#
#        membership.update_column(:spree_user_id, current_spree_user.id)
#      end
#    else
#      if params[:token].blank?
#        raise Bridesmaid::Errors::MoodboardAccessDenied
#      else
#        membership = event.members.find_by_token!(params[:token])
#
#        session[:bridesmaid_party_membership_id] = membership.id
#        session[:bridesmaid_party_event_id] = membership.event.id
#      end
#    end
#  end
end
