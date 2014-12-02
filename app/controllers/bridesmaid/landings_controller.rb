class Bridesmaid::LandingsController < Bridesmaid::BaseController
  def bride
    set_page_titles
  end

  def bridesmaid
    set_page_titles

    user   = Spree::User.find_by_slug!(params[:user_slug])
    event  = BridesmaidParty::Event.find_by_spree_user_id!(user.id)
    member = event.members.find_by_token!(params[:token])

    @bride = user
  end
end
