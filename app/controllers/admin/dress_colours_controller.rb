module Admin
  class DressColoursController < Spree::Admin::BaseController

    def index
      @dress_colours = model_class.all
    end

    def model_class
      ::DressColour
    end

    private
    attr_reader :dress_colours
    helper_method :dress_colours
  end
end

