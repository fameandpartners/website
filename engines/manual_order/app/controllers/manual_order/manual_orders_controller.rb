module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    def index

    end

    def new
      @manual_order_form = Forms::ManualOrderForm.new(Spree::Product.new)
    end

  end
end
