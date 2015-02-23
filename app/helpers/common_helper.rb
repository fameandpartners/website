module CommonHelper
  # override spree method
  # title method 
  def get_title
    # @title  : Spree::Config[:default_seo_title]
    # @category_title is set in the products controller decorator#index
    title_string = @category_title.present? ? @category_title : nil
    if title_string.present?
      title_string
    else
      #[Spree::Config[:site_name], "Dream Formal Dresses"].join(' - ')
      #return default
      @title
    end 
  end

  def get_meta_description
    
    if @category_description.present?
      @category_description
    elsif @description.present?
      @description
    else
      # default description or hardcoded
      default_meta_description
    end
  end


  def get_hreflang(lang)
    href = get_canonical_href

    if lang == :au && !get_canonical_href.include?('/au')
      return "http://#{request.host}/au#{request.fullpath}"    
    end

    if lang == :us && get_canonical_href.include?('/au')
      return href.gsub('/au','')
    end

    href
  end

  def get_canonical_href
    if @product.present?
      return "#{request.host}#{collection_product_path(@product)}"
    end

    if current_site_version.is_australia? && !request.fullpath.include?('/au')
      return "http://#{request.host}/au#{request.fullpath}"
    end

    "http://#{request.host}#{request.fullpath}"
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

