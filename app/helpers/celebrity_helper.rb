module CelebrityHelper

  def celebrity_landing_page?
    params[:lp].present? && params[:lp] == "celebrity"
  end


end