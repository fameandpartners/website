class Users::StyleprofilesController < Users::BaseController
  before_filter :load_user

  respond_to :html, :js

  def show
    @style_profile = get_user_style_profile(current_spree_user)

    @title = 'My Style Profile'

    respond_with(@user) do |format|
      format.html {}
      format.js   {}
    end
  end

  private

    def get_user_style_profile(user)
      # trying to associate user
      if session[:style_profile_id]
        profile = UserStyleProfile.where(id: session[:style_profile_id]).first
        if profile.token == session[:style_profile_access_token]
          if profile.user_id.blank?
            profile.update_column(:user_id, current_spree_user.id)
            #session[:style_profile_id] = nil
            #session[:style_profile_access_token] = nil
          end
          return profile
        end
      end

      # else, try to find profile by user id
      UserStyleProfile.find_by_user_id(@user.id)
    end
end
