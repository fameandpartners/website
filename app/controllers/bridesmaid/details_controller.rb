class Bridesmaid::DetailsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles
    @user_details = bridesmaid_user_profile
  end

  def update
    if update_bridesmaid_user_profile(params[:info])
      redirect_to bridesmaid_party_colour_path
    else
      edit
      render action: :edit
    end
  end

  private

    def update_bridesmaid_user_profile(info)
      bridesmaid_user_profile.assign_attributes(info)
      bridesmaid_user_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
