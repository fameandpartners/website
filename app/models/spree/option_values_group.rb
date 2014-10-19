class Spree::OptionValuesGroup < ActiveRecord::Base
  belongs_to :option_type,
             class_name: 'Spree::OptionType'
  has_and_belongs_to_many :option_values,
                          class_name: 'Spree::OptionValue'

  validates :name,
            presence: true

  validates :presentation,
            presence: true

  validates :option_type,
            presence: true
end
