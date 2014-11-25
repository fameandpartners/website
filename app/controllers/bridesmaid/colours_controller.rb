class Bridesmaid::ColoursController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def edit
    set_page_titles

    @user_details       = bridesmaid_user_profile
    
    @palette = OpenStruct.new(
      colors:   palette_colors,
      selected: selected_colors
    )
  end

  def update
    if store_selected_colors(params[:info][:colours])
      redirect_to bridesmaid_party_consierge_service_path
    else
      # empty or invalid colors
      edit
      render action: :edit
    end
  end

  private

    def selected_colors
      (bridesmaid_user_profile.colors || []).map{|c| c[:original_code]} || palette_colors.first
    end

    def palette_colors
      @palette_colors ||= begin
        colors  = %w{111111 131313 161616 191919 222222 232323 272727 303030 333333 363636}
        colors += %w{393939 424242 444444 464646 494949 525252 555555 585858 616161 646464}
        colors += %w{676767 707070 737373 767676 797979 818181 848484 878787 909090 959595}
        colors += %w{999999 464646 494949 525252 555555 585858 616161 646464 676767 707070}
        colors += %w{737373 767676 797979 818181 848484 878787}
        colors.map{|code| "##{code}"}
      end
    end

    def product_colors
      @product_colors ||= begin
        values = Spree::Variant.color_option_type.try(:option_values) || []
        values.select{|color| color.value.present? }
      end
    end

    def option_value_color_closest_to(color_code)
      escaped_color_code = color_code.to_s.gsub('#', '')[0...6].rjust(6, '0') 
      original_color = Color::HEX.new(escaped_color_code).to_lab

      product_colors_with_ranges = product_colors.map do |product_color|
        similar_color = Color::HEX.new(product_color.value).to_lab
        range = Color::Base.delta_e_cie2000(original_color, similar_color)

        {range: range.round, color: product_color}
      end

      product_colors_with_ranges.min_by{|color| color[:range]}[:color]
    end

    def store_selected_colors(color_codes)
      color_codes = color_codes.split(',').compact.uniq

      colors = []
      color_codes.each do |color_code|
        color = option_value_color_closest_to(color_code)
        colors.push({
          original_code:  color_code,
          name:  color.name,
          code:  color.value,
          id:    color.id
        })
      end
      return false if colors.blank?

      bridesmaid_user_profile.colors = colors
      bridesmaid_user_profile.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
end
