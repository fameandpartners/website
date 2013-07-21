class Users::StyleprofilesController < Users::BaseController
  before_filter :load_user

  respond_to :html, :js

  def show
    @style_profile = UserStyleProfile.find_by_user_id(@user.id)

    respond_with(@user) do |format|
      format.html {}
      format.js   {}
    end
  end
end
