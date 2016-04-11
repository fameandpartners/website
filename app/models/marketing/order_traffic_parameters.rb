module Marketing
  class OrderTrafficParameters < ActiveRecord::Base

    belongs_to :order, class_name: 'Spree::Order'
    attr_accessible :utm_campaign, :utm_source, :utm_medium

  end
end
