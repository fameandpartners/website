class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session = Forms::StyleSession.new(StyleSession.new)
    title('Style Session', default_seo_title)
    description('Fame and Partners offers FREE one-on-one styling sessions with a wardrobe stylist via phone call, text, online chat, video message, and even in-person. Book your styling appointment today!')
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
