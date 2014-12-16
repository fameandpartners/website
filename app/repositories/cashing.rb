require 'active_support/concern'

module Repositories
  module Caching
    extend ActiveSupport::Concern

    included do
      # do something here
    end

    module ClassMethods
      def cache_results(method_name, options = {})
        puts "cache result called #{ options.inspect }"

        # note: in without cache we should reset cache!
        define_method "#{ method_name }_with_cache" do |options = {}|
          Rails.cache.fetch(cache_key, cache_fetch_params(options)) do
            puts "cache block"
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

    def cache_fetch_params(options)
      result = { force: options[:force].present? }
      # process options[:force]
      if Rails.env.development?
        result[:expires_in] = configatron.cache.expire.quickly
      else
        result[:expires_in] = configatron.cache.expire.long
      end

      result
    end
  end
end
