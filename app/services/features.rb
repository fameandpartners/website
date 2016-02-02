require 'redis'
module Features
  # Document the purpose of a feature flag here, this documentation is displayed to admin users in the web UI.
  # { feature_name: "Description or documentation." }
  DEFINED_FEATURES = {
    checkout_fb_login:             "Facebook login on Checkout",
    delivery_date_messaging:       nil,
    enhanced_moodboards:           "Sharing & Comments",
    express_making:                nil,
    fameweddings:                  'Weddings "Shop"',
    getitquick_unavailable:        "Turn off 'getitquick/' pages & Product Express Making",
    gift:                          "DEPRECATED - Remove",
    google_tag_manager:            "Google Tag Manager - Analytics, Trackers & Marketing managed front-end site additions.",
    height_customisation:          "Skirt Length Customisation",
    maintenance:                   "Maintennance Mode - Puts site offline",
    marketing_modals:              "Onsite Marketing Popups & Modals",
    masterpass:                    "MasterCard MasterPass digital wallet on Checkout.",
    moodboard:                     "Moodboards",
    redirect_to_com_au_domain:     "Redirect '/au/' URLs to .com.au",
    sales:                         nil,
    send_promotion_email_reminder: nil,
    shipping_message:              nil,
    style_quiz:                    nil,
    test_analytics:                "Force the rendering of JS Marketing Trackers, usually for testing."
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
      # Safely fallback for deployment.
      # TODO - TTL 2016.02.28 - Remove conditional, just return SimpleKeyValue
      if ActiveRecord::Base.connection.table_exists? SimpleKeyValue.table_name
        SimpleKeyValue
      else
        Redis.new(configatron.redis_options)
      end
    end
  end
end
