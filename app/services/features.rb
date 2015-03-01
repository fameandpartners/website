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
      @rollout ||= begin      
        Rollout.new(kv_store)
      end
    end

    def kv_store
      Redis.new
    end
  end
end 