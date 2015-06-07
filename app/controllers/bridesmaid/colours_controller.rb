class Bridesmaid::ColoursController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles

    @bridesmaid_event = bridesmaid_event_profile
    @palette          = Bridesmaid::Palette.get
    @palette.selected = @bridesmaid_event.colors.map{|color| color[:group] }
  end

  def update
    if store_selected_colors(params[:info][:colours])
      redirect_to bridesmaid_party_dresses_path
    else
      # empty or invalid colors
      edit
      render action: :edit
    end
  end

  private

    def store_selected_colors(groups)
      colors = []
      group_codes = groups.split(',').compact.uniq
      group_codes.each do |group_code|
        color_ids = Bridesmaid::Palette.color_ids_for_group(group_code)
        colors.push({ group: group_code, ids: color_ids })
      end
      bridesmaid_event_profile.colors = colors
      bridesmaid_event_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false

    end
end
