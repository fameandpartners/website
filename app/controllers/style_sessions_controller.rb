class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session = StyleSession.new
    title('Style Session', default_seo_title)
    description('Free one-on-one style advice')
  end

  def create
    @style_session = StyleSession.new(params[:style_session])
    if @style_session.valid?
      StyleSessionMailer.email(@style_session).deliver
      render json: { success: true }
    else
      render json: { errors: @style_session.errors }
    end
  end
end
