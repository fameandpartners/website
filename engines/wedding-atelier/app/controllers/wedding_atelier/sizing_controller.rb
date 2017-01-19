require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class SizingController < ApplicationController
    def index
      render json: Sizing.new, serializer: WeddingAtelier::SizingSerializer
    end
  end
end
