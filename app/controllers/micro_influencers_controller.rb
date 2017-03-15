class MicroInfluencersController < ApplicationController
  layout 'redesign/application'

  def new
    @micro_influencer = Forms::MicroInfluencer.new(MicroInfluencer.new)
  end

  def create
    @micro_influencer = Forms::MicroInfluencer.new(MicroInfluencer.new)
    if @micro_influencer.validate(params)
      MicroInfluencerMailer.email(@micro_influencer).deliver
      render json: { success: true }
    else
      render json: { errors: @micro_influencer.errors }, status: :unprocessable_entity
    end
  end
end
