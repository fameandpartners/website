module StyleQuiz
  #class ApplicationController < ActionController::Base
  class ApplicationController < ApplicationController
    include Concerns::SiteVersion
  end
end
