class StyleSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    @style_session ||= StyleSession.new(
      session_type: params[:session_type] || 'default'
    )
    case @style_session.session_type
    when 'birthday'
      title('Prom Birthday Style Session', default_seo_title)
      @banner_text = 'your birthday styling session'
    when 'prom'
      title('Prom Style Session', default_seo_title)
      @banner_text = 'your prom styling session'
    else # default
      title('Style Session', default_seo_title)
      @banner_text = 'your styling session'
    end

    @description = ""
  end

  def create
    @style_session = StyleSession.new(params[:style_session])
    if @style_session.valid?
      StyleSessionMailer.email(@style_session).deliver
      flash[:notice] = "We're on it!"
      redirect_to success_style_session_path
    else
      new()
      render action: :new
    end
  end

  def success
    title('Thank You', default_seo_title)
  end
end
