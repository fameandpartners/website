class Users::StyleprofilesController < Users::BaseController
  before_filter :load_user

  respond_to :html, :js

  def show
    respond_with(@user) do |format|
      format.html {}
      format.js   {}
    end
  end
end
