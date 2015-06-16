class Spree::OptionValuesGroup < ActiveRecord::Base
  belongs_to :option_type,
             class_name: 'Spree::OptionType'
  has_and_belongs_to_many :option_values,
                          class_name: 'Spree::OptionValue'

  scope :for_colors, -> { where(option_type_id: Spree::OptionType.color) }
  scope :available_as_taxon, -> { where(available_as_taxon: true) }

  validates :name, :presentation, :option_type, presence: true
end
