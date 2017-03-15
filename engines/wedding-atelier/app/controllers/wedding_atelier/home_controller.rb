require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class HomeController < ApplicationController
    def index
      redirect_to events_path
    end
  end
end
