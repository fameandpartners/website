module LandingPagesHelper
 require "base64"

  def pop?
    params[:pop].present? && params[:pop] == 'true'
  end 

  def decode_promocode
    if params[:pc].present?
      Base64.decode64(params[:pc])
    else
      ''
    end
  end

end