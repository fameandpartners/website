module CelebrityHelper

  def celebrity_landing_page?
    params[:lp].present? && params[:lp] == "celebrity"
  end

  def celebrity_kind?(celebrity, kind)
  	if celebrity.kind == kind
  		true
  	else
  		false
  	end
  end

end