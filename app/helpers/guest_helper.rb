module GuestHelper
  def save_token_to_session
    session['guest_checkout_token'] = params[:token] if params[:token].present?
  end

  def check_presence_of_token
    raise ActiveRecord::RecordNotFound unless session['guest_checkout_token'].present?
  end
end
