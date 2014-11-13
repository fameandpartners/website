class Bridesmaid::ColoursController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles

    @user_details       = bridesmaid_user_profile
    @available_colors   = bridesmaid_dresses_colors
  end

  def update
    if update_selected_color(params[:info][:color_name])
      redirect_to bridesmaid_party_consierge_service_path
    else
      edit
      render action: edit
    end
  end

  private

    def bridesmaid_dresses_colors
      @bridesmaid_dresses_colors ||= Spree::Variant.color_option_type.try(:option_values) || []
    end

    def update_selected_color(color_name)
      color = bridesmaid_dresses_colors.find{|color| color.name == color_name }

      bridesmaid_user_profile.color_id   = color.id
      bridesmaid_user_profile.color_name = color.name
      bridesmaid_user_profile.color_code = color.value
      bridesmaid_user_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
