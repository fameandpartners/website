require 'redis'
module Features
  # Document the purpose of a feature flag here, this documentation is displayed to admin users in the web UI.
  # { feature_name: "Description or documentation." }
  DEFINED_FEATURES = {
    afterpay:                      'Enables AfterPay payment method and its notifications on PDP',
    bergen_usa_returns:            '[DEPRECATED] Enable Bergen 3PL return process (background workers and emails) whenever an user creates an order return in the USA',
    checkout_fb_login:             "Facebook login on Checkout",
    cny_delivery_delays:           "Delivery delays on China New Year's period",
    delivery_date_messaging:       nil,
    enhanced_moodboards:           "[DEPRECATED] Sharing & Comments",
    express_making:                '[DEPRECATED] same as the "getitquick_unavailable" flag. Not used anywhere.',
    fameweddings:                  'Weddings "Shop"',
    force_sitewide_ssl:            "Force users to use HTTPS version of the website. Needs to restart server on feature toggle.",
    getitquick_unavailable:        "Turn off 'getitquick/' pages & Product Express Making. Requires server restart",
    delayed_delivery:              "Show delayed delivery option for end users in Checkout page.",
    google_tag_manager:            "Google Tag Manager - Analytics, Trackers & Marketing managed front-end site additions.",
    height_customisation:          "Skirt Length Customisation",
    i_equal_change:                'Toggles i=Change promotion along the site ("/iequalchange" landing page, category/search pages, PDP and Checkout).',
    maintenance:                   "Maintennance Mode - Puts site offline",
    marketing_modals:              "Onsite Marketing Popups & Modals",
    masterpass:                    "MasterCard MasterPass digital wallet on Checkout.",
    moodboard:                     "Moodboards",
    next_logistics:                'Enable Next Logistics 3PL return process, whenever an user creates an order return in Australia',
    price_drop_au:                 "(AU only) Quick & dirty toggle to shown/hide the 'price drop' ribbon on selected items.",
    redirect_to_com_au_domain:     "Redirect '/au/' URLs to .com.au",
    redirect_to_www_and_https:     '[DEPRECATED] Guarantee https://www redirection on Rails routing. Needs to restart server on feature toggle.',
    sales:                         nil,
    sample_sale:                   'Enable/Disable Sample Sale content sitewide.',
    send_promotion_email_reminder: nil,
    shipping_message:              nil,
    style_quiz:                    nil,
    test_analytics:                "Force the rendering of JS Marketing Trackers, usually for testing.",
    wedding_atelier:               'Enables the wedding atelier app, located under the `/wedding-atelier` URL. Needs to restart server on feature toggle.'
  }

  class << self
    extend Forwardable

    def_delegators :rollout, :activate_user, :deactivate_user, :activate, :deactivate, :features, :active?

    def available_features
      (DEFINED_FEATURES.keys + features).uniq
    end

    def description(name)
      DEFINED_FEATURES[name].presence || "Undocumented"
    end

    def inactive?(name)
      !active?(name)
    end

    private

    def rollout
      @rollout ||= Rollout.new(kv_store)
    end

    def kv_store
      SimpleKeyValue
    end
  end
end
