class Campaigns::EmailCaptureController < ApplicationController
  #respond_to :html, :js

  def new
    respond_to do |format|
      format.js { render partial: 'form', layout: false, status: :ok }
    end
  end

  # create
  def create
    @participation = Participation.new(params[:participation])

    if @participation.valid?
      CampaignMonitor.delay.synchronize(@participation.email, nil, Signupreason: "email_capture_#{@participation.content}")
    end
  end
end
