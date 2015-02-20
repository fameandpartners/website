class StyleConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_consultation = StyleConsultation.new
    @title = "Free Style Consultation - " + default_seo_title
    @description = "We can help you create the perfect look."
  end

  def create
    @style_consultation = StyleConsultation.new(params[:style_consultation])
    if @style_consultation.send_request
      flash[:notice] = 'Your request was successfully sent'
      redirect_to success_style_consultation_path
    else
      render action: :new
    end
  end
end
