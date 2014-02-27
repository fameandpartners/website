class QuizzesController < ApplicationController
  layout nil
  include SslRequirement
  ssl_allowed

  skip_before_filter :check_cart
  skip_before_filter :set_locale
  skip_before_filter :set_current_order

  def show
    if spree_user_signed_in?
      session['quiz'] = {}
      session['quiz']['answers'] = {}

      redirect_to quiz_questions_path
    else
      render
    end
  end
end
