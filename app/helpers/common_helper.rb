module CommonHelper
  # override spree method
  # title method
  def get_title
    instance_variable_defined?('@title') ? @title : default_seo_title
  end

  def get_meta_description
    instance_variable_defined?("@description") ? @description : default_meta_description
  end

  def get_hreflang(lang)
    href = get_base_href

    if lang == :au && !href.include?('/au')
      return "http://#{get_host}/au#{request.fullpath}"
    end

    if lang == :us && href.include?('/au')
      return href.gsub('/au','')
    end

    href
  end

  def get_canonical_href
    href = get_base_href

    if @product.present?
      product_path = collection_product_path(@product, :color => @product.default_color)
      href = "http://#{get_host}#{product_path}"
    end
    href.gsub(/\?.*/,'')
  end

  def get_host
    configatron.host
  end

  def get_base_href
    if current_site_version.is_australia? && !request.fullpath.include?('/au')
      return "http://#{get_host}/au#{request.fullpath}"
    end

    "http://#{get_host}#{request.fullpath}"
  end

  # social links helper
  def facebook_share_button(share_url)
    if Rails.env.development?
      share_url = 'http://www.fameandpartners.com/' + share_url
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

  def addthis_buttons(share_url, product_image_url)
    render partial: 'shared/addthis_buttons', locals: {
      share_url: share_url,
      product_image_url: product_image_url
    }
  end
end
