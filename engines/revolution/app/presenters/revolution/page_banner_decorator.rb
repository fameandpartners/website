module Revolution
  class PageBannerDecorator
    attr_accessor :page, :params, :position, :size, :no_of_banners

    def initialize(page, params, position = 1, size = 'full')
      @page     = page
      @params   = params
      @position = position
      @size     = size
    end

    def image
      if custom?
        "//#{configatron.asset_host}/pages#{asset_safe_page_path}/#{custom_banner}.jpg"
      else
        page.banner_image(position, size)
      end
    end

    def image_alt_text
      page.alt_text(position, size)
    end

    def no_of_banners
      page.no_of_banners
    end

    # The default Revolution Page Path is 'dresses/*'.
    # The '*' doesnt work as a path on on S3, so remove it.
    def asset_safe_page_path
      page.path.to_s.gsub('/*', '')
    end

    def display?
      custom_banner != 'none'
    end

    def custom?
      custom_banner.present?
    end

    def custom_banner
      params[:lpi]
    end

  end
end
