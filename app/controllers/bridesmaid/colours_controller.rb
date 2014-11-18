class Bridesmaid::ColoursController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles

    @user_details       = bridesmaid_user_profile
    @available_colors   = ordered_bridesmaid_dresses_colors
  end

  def update
    if update_selected_color(params[:info][:color_id])
      redirect_to bridesmaid_party_consierge_service_path
    else
      edit
      render action: edit
    end
  end

  private
    def bridesmaid_dresses_colors
      @bridesmaid_dresses_colors ||= begin
        values = Spree::Variant.color_option_type.try(:option_values) || []
        values.select{|color| color.value.present? }
      end
    end

    def ordered_bridesmaid_dresses_colors
      @ordered_colors ||= bridesmaid_dresses_colors.sort_by {|color| color.hsv_value }
    end

    def update_selected_color(color_id)
      #color = bridesmaid_dresses_colors.find{|color| color.id == color_id }
      color = Spree::OptionValue.where(id: color_id).first || bridesmaid_dresses_colors.first

      bridesmaid_user_profile.color_id   = color.id
      bridesmaid_user_profile.color_name = color.name
      bridesmaid_user_profile.color_code = color.value
      bridesmaid_user_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
