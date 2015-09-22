class QuestionsController < ApplicationController
  layout nil
  include SslRequirement
  ssl_allowed

  before_filter :authenticate_spree_user!

  skip_before_filter :check_cart
  skip_before_filter :set_locale
  skip_before_filter :set_current_order

  caches_action :index,
                expires_in: configatron.cache.expire.long,
                cache_path: proc{ |c| c.request.url + '.' + c.request.format.ref.to_s }

  def index
    @quiz = Quiz.last
    @questions_by_steps = @quiz.questions.includes(:answers).order('position ASC').group_by(&:step)
  end
end
