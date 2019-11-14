module Spree
  class QuadpayOrder < ActiveRecord::Base
    attr_accessible :qp_order_token
    belongs_to :payment
  end
end
