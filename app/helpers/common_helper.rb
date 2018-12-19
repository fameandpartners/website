module CommonHelper
  def get_facebook_app_id
    ENV.fetch('FACEBOOK_APP_ID', '591959187490267')
  end

  # override spree method
  # title method
  def get_title
    instance_variable_defined?('@title') ? @title : ''
  end

  def get_meta_description
    @description
  end

  def get_hreflang(lang)
    site_version = SiteVersion.by_permalink_or_default(lang)
    detector.site_version_url(request.url, site_version)
  end

  def get_canonical_href
    canonical_url = Addressable::URI.parse(request.url)

    if @product.present?
      canonical_url.path = collection_product_path(@product)
    end

    if @canonical
      canonical_url.path  = ''
      canonical_url.query = nil
      canonical_url = URI.join(canonical_url.to_s, @canonical)
    end

    canonical_url.query = nil
    canonical_url.to_s
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

  private def detector
    UrlHelpers::SiteVersion::Detector.detector
  end
end
