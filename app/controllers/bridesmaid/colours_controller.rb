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

    # palette from wireframe
    def palette_colors
      @palette_colors ||= begin
        colors  = %w{392E37 3D303C 413644 3A2E3E 2B2838 242231 22202D 231E2A 171621 10121B 0E1018 }
        colors += %w{74555C A77B7B 9B7A7B 7C6976 685F6F 5B5666 4A4958 393B4D 292E3F 212736 1F202C }
        colors += %w{DAA992 FDF4E8 F3DAC6 CEA99B B09590 9E8783 8F7674 7A6262 58474D 3F343C 2F2930 }
        colors += %w{E9BC8E FDF5E7 F6E3C3 E6BF96 CEA184 B38B75 9C7965 896C5C 715A50 5E4B47 4E403E }
        colors += %w{A3642E C3894E CE8B47 B8773A A16A35 946134 83572F 78502A 654425 5B3C25 523622 }
        colors += %w{8C4510 A25112 A75713 984C11 884610 7A3F0F 6C380E 5D330D 46260A 3D220A 3A1E0A }
        colors += %w{251101 331905 422107 4A2509 4D280A 522A09 502A0A 4D290B 4A260B 43240B 3B2009 }
        colors.map{|code| "##{code}"}
      end
    end
=begin
    # grey colors palette
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

    # avaialble_color_options_palette
    def palette_colors
      @palette_colors ||= begin
        option_type = Spree::OptionType.where(name: 'dress-color').first
        option_type.option_values.
          select{|option_value| option_value.value.present? }.
          sort_by{|option_value| option_value.hsv_value }.
          collect{|option_value| option_value.value }.compact
      end
    end
=end

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
