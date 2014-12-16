class Bridesmaid::DetailsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles
    @user_details = bridesmaid_user_profile

    if flash[:just_signed_up]
      @render_conversion_pixel = true
    end
  end

  def update
    if update_bridesmaid_user_profile(params[:info])
      redirect_to bridesmaid_party_consierge_service_path
    else
      edit
      render action: :edit
    end
  end

  private

    def update_bridesmaid_user_profile(info)
      bridesmaid_user_profile.wedding_date = info[:wedding_date]
      bridesmaid_user_profile.status = info[:status]
      bridesmaid_user_profile.bridesmaids_count = info[:bridesmaids_count]
      #bridesmaid_user_profile.special_suggestions = (info[:special_suggestions] == 'true')
      bridesmaid_user_profile.paying_for_bridesmaids = info[:paying_for_bridesmaids]

      bridesmaid_user_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
