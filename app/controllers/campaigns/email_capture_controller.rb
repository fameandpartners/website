class Campaigns::EmailCaptureController < ApplicationController
  def create
    Marketing::Subscriber.new(
      token: cookies['utm_guest_token'],
      email: params[:email],
      campaign: params[:content],
      promocode: params[:promocode],
      sign_up_reason: "email_capture_#{params[:content]}"
    ).create

    render :json => { status: 'ok' }, status: :ok

  rescue CreateSend::Unauthorized => e
    if Rails.env.development?
      render :json => { status: 'ok' }, status: :ok
    else
      render :json => { status: 'invalid' }, status: :error
    end

  rescue Exception => e
    render :json => { status: 'invalid' }, status: :ok
  end
end
