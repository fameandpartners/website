module Revolution
  class PageBannerDecorator
    attr_accessor :page, :params

    def initialize(page, params)
      @page   = page
      @params = params
    end

    def image
      if custom?
        "#{configatron.asset_host}/pages#{asset_safe_page_path}/#{custom_banner}.jpg"
      else
        page.banner_image
      end
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
