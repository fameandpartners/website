class Campaigns::EmailCaptureController < ApplicationController
  def send_customerio_event
    begin
      Marketing::CustomerIOEventTracker.new.track(
        current_spree_user,
        'email_capture_modal',
        email:            params[:email],
        promocode:        params[:promocode]
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end

  def create
    Marketing::Subscriber.new(
      token:          cookies['utm_guest_token'],
      email:          params[:email],
      campaign:       params[:content],
      promocode:      params[:promocode],
      sign_up_reason: "email_capture_#{params[:content]}",
      user:           current_spree_user
    ).create

    begin
      if params[:promocode].present?
        UserCart::PromotionsService.new(
          order: current_order,
          code: params[:promocode]
        ).apply
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end

    send_customerio_event

    render :json => { status: 'ok' }, status: :ok

  rescue CreateSend::Unauthorized => e
    NewRelic::Agent.notice_error(e)
    if Rails.env.development?
      render :json => { status: 'ok' }, status: :ok
    else
      render :json => { status: 'invalid' }, status: :error
    end

  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    render :json => { status: 'invalid' }, status: :error
  end
end
