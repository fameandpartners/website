class Campaigns::EmailCaptureController < ApplicationController
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
