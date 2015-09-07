module Preferences
  class TopBannerPresenter
    attr_reader :preference

    def initialize(site_version)
      @preference = Preferences::TopBanner.new(site_version)
    end

    def right_text
      preference.right_text
    end

    def center_text
      preference.center_text
    end

    def customer_service_contact
      "24/7 CUSTOMER SERVICE 1300 222 222"
    end

    def free_shipping_in_AU_and_NZ
      "FREE SHIPPING WITHIN AUSTRALIA AND NEW ZEALAND"
    end
  end
end
