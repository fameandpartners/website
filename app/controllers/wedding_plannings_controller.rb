class WeddingPlanningsController < ApplicationController
  layout 'redesign/application'

  def create
    @wedding_planning = Forms::WeddingPlanning.new(WeddingPlanning.new)
    if @wedding_planning.validate(params)
      @wedding_planning.save
      WeddingConsultationMailer.email(@wedding_planning).deliver if params[:should_contact]
      render json: { success: true }
    else
      render json: { errors: @wedding_planning.errors }, status: :unprocessable_entity
    end
  end
end
