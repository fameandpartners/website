class Campaigns::EmailCaptureController < ApplicationController
  def new
    respond_to do |format|
      format.js { render partial: 'form', layout: false, status: :ok }
    end
  end

  def create
    Marketing::Subscriber.new(
      token: cookies['utm_guest_token'],
      email: params[:email],
      campaign: params[:content],
      promocode: params[:promocode],
      sign_up_reason: "email_capture_#{params[:email]}"
    ).create

    render :json => { status: 'ok' }, status: :ok
  rescue Exception => e
    render :json => { status: 'invalid' }, status: :error
  end
end
