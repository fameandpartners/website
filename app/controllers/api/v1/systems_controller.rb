module Api
  module V1
    class SystemsController < ApplicationController
      include SslRequirement

      def clear_cache
        #nothing to see here
        if params['systems_key'] = 'f3UwF9ftw'
          Rails.cache.clear
          Raven.capture_exception("Cache reset by nodey.")
        end
        render :json => {:success=>true}, status: 200
      end

    end

  end
end