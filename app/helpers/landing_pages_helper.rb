module LandingPagesHelper
 require "base64"

  def pop?
    params[:pop].present? && params[:pop] == 'true'
  end 

  def decode_promocode
    Base64.decode64(params[:pc])
  end

end