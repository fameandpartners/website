module Api
  module V1
    class ProfilesController < Users::BaseController
      before_filter :load_user

      respond_to :json

      def show
        respond_with @user.to_json(:only => [:email, :sign_in_count, :first_name, :last_name])
      end


    end


  end
end
