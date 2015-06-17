class WeddingConsultationsController < ApplicationController

  layout 'redesign/application'

  def new
    @wedding_consultation = WeddingConsultation.new
    title('Wedding Consultation', default_seo_title)
    @description = ""
  end

  def create
    @wedding_consultation = WeddingConsultation.new(params[:wedding_consultation])
    if @wedding_consultation.valid?
      StyleSessionMailer.email(@wedding_consultation).deliver
      flash[:notice] = "We're on it!"
      redirect_to success_wedding_consultation_path
    else
      render action: :new
    end
  end

  def success
    title('Thank You', default_seo_title)
  end
end
