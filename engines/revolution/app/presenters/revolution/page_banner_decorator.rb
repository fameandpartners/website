module Revolution
  class PageBannerDecorator
    attr_accessor :page, :params

    def initialize(page, params)
      @page = page
      @params = params
    end

    def image
      if custom?
        "//#{configatron.asset_host}/pages#{page.path}/#{custom_banner}.jpg"
      else
        page.banner_image
      end
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
