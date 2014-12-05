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

=begin
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
=end

=begin
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
          collect{|option_value| option_value.value }.compact.uniq
      end
    end

    # static palette from available colors
    def palette_colors
      @palette_colors ||= begin
        colors  = %w{ 000000 003200 006D43 009875 012D60 01A7F6 029351 033C21 0891CF 0AB9B7 0E3299 }
        colors += %w{ 0F0063 151834 15558B 1D9946 269C36 343432 41B5A8 421160 45335D 620217 666666 }
        colors += %w{ 6B3A62 7ED6C6 808080 837478 870200 88C5CA 8C001A 8F0620 96C0E6 9B171F 9BD8D9 }
        colors += %w{ 9D6A4B A3A7A8 A68F97 AD225E ADD418 B60003 B91B29 B9B4B1 B9CDD8 BBA1CE BCE4DC }
        colors += %w{ C00D1D C0C0C0 C74375 C7C3C9 CA2F2D CFDEE1 D09C9E D0D1CC D5C5E9 D6AE28 D6C7B4 }
        colors += %w{ DDF1FA DFD1AE E08E7A E3075C E4B0DF E7CBC8 E7D0A6 E82658 E9658A E9B600 EBE5CD }
        colors += %w{ ECE6D3 ED0234 ED675A EDB32D F14873 F1E4D3 F3D623 F4FF02 F6D400 F7742F F9D9DC }
        colors += %w{ F9DAD8 F9E4CC FAB6B7 FAF8E9 FCCDC5 FDC3C2 FDD4DD FF0033 FF6903 FF7800 FF7F01 }
        colors += %w{ FF8434 FF95CB FFBF98 FFC598 FFE100 FFFFF0 FFFFFF B4A794 CCCCFF E0E0E0 F4E6CB }
        colors.map{|code| "##{code}"}
      end
    end
=end
=begin

    def product_colors
      @product_colors ||= begin
        values = Spree::Variant.color_option_type.try(:option_values) || []
        values.select{|color| color.value.present? }
      end
    end

    def option_value_color_closest_to(color_code)
      escaped_color_code = color_code.to_s[0..6].rjust(6, '0') 
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
=end
end
