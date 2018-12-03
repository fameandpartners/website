require 'redis'
module Features
  # Document the purpose of a feature flag here, this documentation is displayed to admin users in the web UI.
  # { feature_name: "Description or documentation." }
  DEFINED_FEATURES = {
    afterpay:                      'Enables AfterPay payment method and its notifications on PDP',
    bergen_usa_returns:            '[DEPRECATED] Enable Bergen 3PL return process (background workers and emails) whenever an user creates an order return in the USA',
    checkout_fb_login:             "Facebook login on Checkout",
    cny_delivery_delays:           "Delivery delays on China New Year's period",
    force_sitewide_ssl:            "Force users to use HTTPS version of the website. Needs to restart server on feature toggle.",
    google_tag_manager:            "Google Tag Manager - Analytics, Trackers & Marketing managed front-end site additions.",
    maintenance:                   "Maintennance Mode - Puts site offline",
    masterpass:                    "MasterCard MasterPass digital wallet on Checkout.",
    next_logistics:                'Enable Next Logistics 3PL return process, whenever an user creates an order return in Australia',
    sales:                         nil,
    shipping_message:              nil,
    test_analytics:                "Force the rendering of JS Marketing Trackers, usually for testing.",
    refulfill:                     "Check new orders coming in against inventory.",
    batching:                      "Batch line items into styles for production.",
    new_account:                   "Enables new account pages for login, signup and forgot password.",
    orderbot:                      "Enables Integration with OrderBot"
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
