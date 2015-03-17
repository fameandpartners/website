require 'active_support/concern'

module Repositories
  module CachingSystem
    extend ActiveSupport::Concern

    # global settings
    # Repositories::CachingSystem.cache_fetch_params
    def self.cache_fetch_params(options = {})
      result = {
        force: options.delete(:force)
      }

      if Rails.env.development?
        result[:expires_in] = configatron.cache.expire.quickly
      else
        result[:expires_in] = configatron.cache.expire.long
      end

      result
    end

    included do
      # do something here
    end

    module ClassMethods
      def cache_results(method_name)
        # note: in without cache we should reset cache!
        define_method "#{ method_name }_with_cache" do |options = {}|
          Rails.cache.fetch(cache_key, cache_fetch_params(options)) do
            call_method("#{ method_name }_without_cache", options)
          end
        end
        alias_method_chain method_name, :cache
      end
    end

    def call_method(name, *arguments)
      if self.class.instance_method(name).arity == 0
        send(name)
      else
        send(name, *arguments)
      end
    end

    def reset_cache!
      Rails.cache.delete(cache_key)
    end

    def cache_fetch_params(options = {})
      Repositories::CachingSystem.cache_fetch_params(options)
    end
  end
end
