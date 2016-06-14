class WeddingConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @wedding_consultation = WeddingConsultation.new
    title('Wedding Consultation', default_seo_title)
    description('We can help you create the perfect wedding look.')
  end

  def create
    @wedding_consultation = WeddingConsultation.new(params[:wedding_consultation])
    if @wedding_consultation.valid?
      WeddingConsultationMailer.email(@wedding_consultation).deliver
      flash[:notice] = 'Your request was successfully sent'
      redirect_to success_wedding_consultation_path
    else
      render action: :new
    end
  end
end
