class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session = StyleSession.new
    title('Style Session', default_seo_title)
    @description = ""
  end

  def create
    @style_session = StyleSession.new(params[:style_session])
    if @style_session.valid?
      StyleSessionMailer.email(@style_session).deliver
      flash[:notice] = "We're on it!"
      redirect_to success_style_session_path
    else
      render action: :new
    end
  end

  def success
    title('Thank You', default_seo_title)
  end
end
