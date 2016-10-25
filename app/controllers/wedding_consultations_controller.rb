class WeddingConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @wedding_consultation = Forms::WeddingConsultation.new(WeddingConsultation.new)
    title('Wedding Consultation', default_seo_title)
    description('Fame and Partners offers FREE one-on-one wedding consultations for the bride and entire bridal partyvia phone call, text, online chat, video message, and even in-person. Book your styling appointment with our wardrobe stylist today!')
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
