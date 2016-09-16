class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session = Forms::StyleSession.new(StyleSession.new)
    title('Style Session', default_seo_title)
    description('Free one-on-one style advice')
  end

  def create
    @style_session = Forms::StyleSession.new(StyleSession.new)
    if @style_session.validate(params[:forms_style_session])
      StyleSessionMailer.email(@style_session).deliver
      render json: { success: true }
    else
      render json: { errors: @style_session.errors }
    end
  end
end
