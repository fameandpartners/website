module Api
    module V1
      class TrackingController < ApplicationController 
        respond_to :json
        skip_before_filter :verify_authenticity_token

        def track          
          head :no_content
        end
      end
    end
  end
  