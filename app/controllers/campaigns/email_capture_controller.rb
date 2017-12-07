class Campaigns::EmailCaptureController < ApplicationController
  def send_customerio_event
    begin
      opts = {
        email:     params[:email],
        promocode: params[:promocode]
      }

      if params[:timer].present?
        opts[:timer] = params[:timer]
        opts[:expires] = Time.zone.now + params[:timer].to_i.hours
      end

      tracker = Marketing::CustomerIOEventTracker.new
      unless current_spree_user
        tracker.identify_user_by_email(params[:email], current_site_version)
      end
      tracker.track(current_spree_user || params[:email], 'email_capture_modal', opts)
    rescue StandardError => e
      Rails.logger.error('[customer.io] Failed to send event: email_capture_modal')
      Rails.logger.error(e)
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

    # EmailCapture.new({ service: :mailchimp }, email: params[:email], newsletter: true,
    #                              current_sign_in_ip: request.remote_ip,
    #                              landing_page: session[:landing_page],
    #                              utm_params: session[:utm_params], site_version: current_site_version.name,
    #                              form_name: 'Sitewide Modal Form').capture

    begin
      if params[:promocode].present?
        service = UserCart::PromotionsService.new(
          order: current_order,
          code: params[:promocode]
        )
        service.apply

        # A simpler test for "did the promocode apply?"
        #
        # Note that promocodes apply to a cart, but are not
        # considered 'eligible' unless there are items
        # in the cart for them to be applied to.
        unless current_order.normalized_coupon_code == params[:promocode]
          NewRelic::Agent.notice_error(
            "Failed to apply modal promocode to cart",
            email:        params[:email],
            promocode:    params[:promocode],
            order_number: current_order.number,
            reason:       service.message
          )
        end
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end

    send_customerio_event

    render :json => { status: 'ok' }, status: :ok

  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    render :json => { status: 'invalid' }, status: :error
  end

  def subscribe
    captured_email = EmailCapture.new({ service: params[:service] }, email: params[:email],
                                 current_sign_in_ip: request.remote_ip,
                                 landing_page: session[:landing_page],
                                 utm_params: session[:utm_params], site_version: current_site_version.name,
                                 form_name: params[:source]).capture
     message = captured_email.blank? ? 'invalid' : 'done' # TODO: This isn't pretty, as it should live in the EmailCapture class.

    render json: { status: message }
  end
end
