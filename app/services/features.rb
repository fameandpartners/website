require 'redis'
module Features
  DEFINED_FEATURES = %i(checkout_fb_login
                        content_revolution
                        delivery_date_messaging
                        enhanced_moodboards
                        express_making
                        fameweddings
                        getitquick_unavailable
                        gift
                        google_tag_manager
                        height_customisation
                        maintenance
                        marketing_modals
                        masterpass
                        moodboard
                        redirect_to_com_au_domain
                        sales
                        send_promotion_email_reminder
                        shipping_message
                        style_quiz
                        test_analytics
                        test_flag
                        )

  class << self
    extend Forwardable

    def_delegators :rollout, :activate_user, :deactivate_user, :activate, :deactivate, :features, :active?

    def available_features
      (DEFINED_FEATURES + features).uniq
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
      # TODO - TTL 2016.02.28 - Remove conditional, just return FeatureFlag
      if ActiveRecord::Base.connection.table_exists? FeatureFlag.table_name
        FeatureFlag
      else
        Redis.new(configatron.redis_options)
      end
    end
  end
end
