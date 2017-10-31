class MyerStylingSessionsController < ApplicationController

  layout 'redesign/application'

  def new
    if current_site_version.permalink == 'au'
      @myer_styling_session = Forms::MyerStylingSession.new(MyerStylingSession.new)
      title('Free styling at Meyer', default_seo_title)
      description('Try on Fame and Partners\' custom, made-to-order dresses in person at Meyer stores around Australia. Book your free styling session now!')
    else
      respond_to do |format|
        format.html { render "errors/404", status: 404, layout: 'redesign/application' }
        format.all  { render nothing: true, status: 404 }
      end
    end
  end

  def create
    @myer_styling_session = Forms::MyerStylingSession.new(MyerStylingSession.new)
    if @myer_styling_session.validate(params[:forms_myer_styling_session])
      MyerStylingSessionMailer.email(@myer_styling_session).deliver
      render json: { success: true }
    else
      render json: { errors: @myer_styling_session.errors }
    end
  end
end
