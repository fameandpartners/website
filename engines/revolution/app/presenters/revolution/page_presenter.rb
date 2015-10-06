module Revolution
  class PagePresenter
    attr_accessor :page, :params
    delegate :heading, :sub_heading, :get, :path, :to => :page

    def initialize(page, params)
      @page = page
      @params = params
    end

    def banner_image
      if custom_banner?
        "//#{configatron.asset_host}/pages#{page.path}/#{custom_banner}.jpg"
      else
        page.banner_image
      end
    end

    def display_banner?
      custom_banner != 'none'
    end

    def custom_banner?
      custom_banner.present?
    end

    def custom_banner
      params[:lpi]
    end

  end
end
