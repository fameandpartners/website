class WeddingConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @wedding_consultation = Forms::WeddingConsultation.new(WeddingConsultation.new)
    title('Wedding Consultation', default_seo_title)
    description('We can help you create the perfect wedding look.')
  end

  def create
    @wedding_consultation = Forms::WeddingConsultation.new(WeddingConsultation.new)
    if @wedding_consultation.validate(params[:forms_wedding_consultation])
      WeddingConsultationMailer.email(@wedding_consultation).deliver
      render json: { success: true }
    else
      render json: { errors: @wedding_consultation.errors }
    end
  end
end
