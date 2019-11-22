require 'reform'

module Forms
  class MakingOptionForm < ::Reform::Form
    property :code
    property :name
    property :description
    property :delivery_period
    property :making_time_business_days
    property :flat_price_usd
    property :flat_price_aud
    property :percent_price_usd
    property :percent_price_aud
    property :position
    property :delivery_time_days

    validates :code, presence: true
    validates :name, presence: true
    validates :description, presence: true
    validates :delivery_period, presence: true
    validates :making_time_business_days, presence: true, numericality: { greater_than: 0 }
    validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :delivery_time_days, presence: true, numericality: { greater_than: 0 }
    # validates :code, uniqueness: { scope: :name } # TODO: Unique validate code and name
  end
end
