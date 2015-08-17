module Spree
  class MasterPassController < ApplicationController
    def express

    end

    def confirm

    end

    def refund

    end

    private

    def payment_method
      Spree::PaymentMethod.find(params[:payment_method_id])
    end

    def provider
      payment_method.provider
    end

  end
end