module StyleQuiz
  #class ApplicationController < ActionController::Base
  class ApplicationController < ApplicationController
    #include Concerns::SiteVersion

    def check_site_version
      # don't want to fight with different site version in single request anymore
      return :no_change
    end
  end
end
