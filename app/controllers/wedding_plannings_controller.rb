class WeddingPlanningsController < ApplicationController
  layout 'redesign/application'

  def create
    @wedding_planning = Forms::WeddingPlanning.new(WeddingConsultation.new)
    if @wedding_planning.validate(params)
      WeddingConsultationMailer.email(@wedding_planning).deliver
      render json: { success: true }
    else
      render json: { errors: @wedding_planning.errors }, status: :unprocessable_entity
    end
  end
end
