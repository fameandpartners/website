class Bridesmaid::MembershipsController < Bridesmaid::BaseController
  before_filter :require_completed_profile!

  def create
    event = bridesmaid_user_profile

    note = params[:note]
    friends = params[:friends].values

    friends.each do |friend|
      first_name, last_name = friend[:full_name].split(' ')
      membership = event.members.build
      membership.first_name = first_name
      membership.last_name = last_name
      membership.email = friend[:email]

      if membership.save
        BridesmaidPartyMailer.delay.invite(membership)
      end
    end

    respond_to do |format|
      format.html do
        redirect_to wishlist_path
      end
      format.json do
        render json: {}, status: :ok
      end
    end
  end
end
