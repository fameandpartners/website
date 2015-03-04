require 'redis'
module Features
  class << self
    extend Forwardable
    
    def_delegators :rollout, :active?, :activate_user, :deactivate_user, :activate, :deactivate
    
    def inactive?(name)
      !active?(name)
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
      Redis.new(:url => configatron.redis_options)
    end
  end
end 
