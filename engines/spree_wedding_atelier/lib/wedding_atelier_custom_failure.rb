class WeddingAtelierCustomFailure < Devise::FailureApp

  def redirect_url
    if scope == :spree_user
      is_wedding_atelier = request.env['REQUEST_PATH'] =~ /wedding-atelier/
      if is_wedding_atelier
        "/wedding-atelier/sign_in?return_to=#{request.env['REQUEST_PATH']}"
      else
        new_spree_user_session_path
      end
    else
      super
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
