module MarketingHelper
  def marketing_banner_image_url(banner_name)
    # here should be check  
    if FileTest.exists?(File.join('app', 'assets', 'images', 'banners', banner_name))
      "/assets/banners/#{params[:dmb]}"
    else
      nil
    end
  end

  def marketing_banner
    if @display_marketing_banner && params[:dmb].present?
      image_url = marketing_banner_image_url(params[:dmb])
      return '' if image_url.blank?
      content_tag :div, class: 'row' do
        content_tag :div, class: 'grid-12' do
          image_tag(image_url,
            style: 'width: 100%;',
            onerror: "window.switchToAltImage(this, '/assets/banners/default.jpg')"
          )
        end
      end
    end
  end
end
