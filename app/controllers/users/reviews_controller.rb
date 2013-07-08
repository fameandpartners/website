class Users::ReviewsController < Users::BaseController
  def index
    respond_with([]) do |format|
      format.html {}
      format.js   {}
    end
  end
end
