class Campaigns::EmailCaptureController < ApplicationController
  #respond_to :html, :js

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

#  # create
#  def create
#    @participation = Participation.new(:email => params[:email], :content => params[:email])
#
#    if @participation.valid?
#      CampaignMonitor.delay.synchronize(@participation.email, nil, Signupreason: "email_capture_#{@participation.content}")
#      render :json => { status: 'ok' }, status: :ok
#    else
#      render :json => { status: 'invalid' }, status: :error
#    end
#
#    # respond_to do |format|
#    #   format.html { render partial: 'form', layout: false }
#    #   format.js   { render: 'json' => {   }, status: :ok }
#    # end
#  end
end
