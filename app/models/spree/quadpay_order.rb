module Spree
  class QuadpayOrder < ActiveRecord::Base
    attr_accessible
    belongs_to :payment
  end
end
