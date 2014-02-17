module CommonHelper
  # override spree method
  # title method 
  def get_title
    # @title  : Spree::Config[:default_seo_title]
    title_string = @title.present? ? @title : accurate_title
    if title_string.present?
      title_string
    else
      [Spree::Config[:site_name], "Dream Formal Dresses"].join(' - ')
    end 
  end

  def get_meta_description
    if @description.present?
      @description
    else
      # default description or hardcoded
      default_meta_description
    end
  end

  # social links helper
  def facebook_share_button(share_url)
    if Rails.env.development?
      share_url = 'http://feature.fameandpartners.com/collection/long-dresses/posuere_placerat_dress'
    end
    options = {
      'class' => 'fb-like',
      'data-href' => share_url,
      'data-layout' => 'button',
      'data-action' => 'like',
      'data-show-faces' => 'false',
      'data-share' => 'false'
    }
    content_tag(:div, '', options)
  end

  def pin_share_button(share_url, product_image_url, description)
    if Rails.env.development?
      share_url = 'http://feature.fameandpartners.com/collection/long-dresses/posuere_placerat_dress'
    end
    url_params = {
      url: share_url,
      media: product_image_url,
      description: description
    }
    url = "//www.pinterest.com/pin/create/button/?#{ url_params.to_query }"
    link_options = { 'data-pin-do' => 'buttonPin', 'data-pin-config' => 'none' }

    link_to image_tag("//assets.pinterest.com/images/pidgets/pinit_fg_en_rect_gray_20.png"), url, link_options
  end

  def addthis_links
    javascript_include_tag "//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f711fa532bc34ad"
  end
end

