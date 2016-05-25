class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session ||= StyleSession.new(
      session_type: params[:session_type] || 'default'
    )
    title("#{ @style_session.name.capitalize } Style Session", default_seo_title)
    @banner_text = "your #{ @style_session.name.downcase } styling session"
    @description = ""
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
