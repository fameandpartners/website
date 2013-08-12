class QuizzesController < ApplicationController
  layout nil
  include SslRequirement
  ssl_allowed

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
