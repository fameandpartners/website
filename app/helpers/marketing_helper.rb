module MarketingHelper
  def marketing_banner_image_url(style = nil)
    banner_name = params[:dmb] || cookies[:dmb]
    return nil if banner_name.blank?

    if style.present?
      ext = File.extname(banner_name)
      banner_name = File.basename(banner_name, ext)
      banner_name = "#{banner_name}_#{style.to_s}#{ext}"
    end

    if FileTest.exists?(File.join('app', 'assets', 'images', 'banners', banner_name))
      "/assets/banners/#{ banner_name }"
    else
      nil
    end
  end

  def marketing_banner
    if @display_marketing_banner
      image_url = marketing_banner_image_url
      return '' if image_url.blank?
      content_tag :div, class: 'row' do
        content_tag :div, class: 'grid-12' do
          image_tag(image_url,
            onerror: "window.switchToAltImage(this, '/assets/banners/birthday.gif')",
            style: 'width: 100%;'
          )
        end
      end
    end
  end

  def marketing_landing_page?
    params[:lp].present?
  end

  def show_small_product_images?
    marketing_landing_page?
  end
end
