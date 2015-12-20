require 'redis'
module Features
  DEFINED_FEATURES = %i(checkout_fb_login
                          content_revolution
                          delivery_date_messaging
                          enhanced_moodboards
                          fameweddings
                          maintenance
                          send_promotion_email_reminder
                          shipping_message
                          test_analytics
                          express_making
                          gift
                          google_tag_manager
                          marketing_modals
                          masterpass
                          moodboard
                          style_quiz
                          redirect_to_com_au_domain
                          sales
                          getitquick_unavailable)

  class << self
    extend Forwardable

    def_delegators :rollout, :activate_user, :deactivate_user, :activate, :deactivate, :features
    
    def inactive?(name)
      !active?(name)
    end

    def active?(feature, user = nil)
      raise ArgumentError.new("Features.active?: Undefined feature :#{feature.to_sym}") unless DEFINED_FEATURES.include?(feature.to_sym)
      rollout.active?(feature, user)
    end
  
    private

    def rollout
      return Rollout.new(kv_store)
      # code below not thread-safe
      # unstable work with forks on production. some hook like after(:fork) { reconnect_to_redis } required
      @rollout ||= begin      
        Rollout.new(kv_store)
      end
    end

    def kv_store
      Redis.new(configatron.redis_options)
    end
  end
end