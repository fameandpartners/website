module LandingPagesHelper
 require "base64"

  def pop?
    params[:pop].present? && params[:pop] == 'true'
  end 

  def decode(p)
    if p.present?
      Base64.decode64(p)
    else
      ''
    end
  end

end