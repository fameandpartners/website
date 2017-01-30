class WeddingConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @wedding_consultation = Forms::WeddingConsultation.new(WeddingConsultation.new)
    title('Wedding Consultation', default_seo_title)
    description('Fame and Partners offers FREE one-on-one wedding consultations for the bride and entire bridal partyvia phone call, text, online chat, video message, and even in-person. Book your styling appointment with our wardrobe stylist today!')
  end

  def create
    @wedding_consultation = Forms::WeddingConsultation.new(WeddingConsultation.new)
    form_params = params[:forms_wedding_consultation]
    if @wedding_consultation.validate(form_params)
      if form_params[:first_name] & form_params[:last_name]
        form_params[:full_name] = form_params[:first_name] + wedding_consultation_params[:last_name]
      end

      if WeddingConsultation.create!(form_params)
        WeddingConsultationMailer.email(@wedding_consultation).deliver
        render json: { success: true }
      end
    else
      render json: { errors: @wedding_consultation.errors }
    end
  end
end
