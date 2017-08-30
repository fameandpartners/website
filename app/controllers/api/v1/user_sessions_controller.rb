module Api
  module V1
    class UserSessionsController < Users::BaseController
      before_filter :load_user

      respond_to :json

      def show
        respond_with @user
      end


    end


  end
end
