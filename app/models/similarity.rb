class Similarity < ActiveRecord::Base
  default_scope order('similarities.coefficient ASC')

  belongs_to :original,
             class_name: 'Spree::OptionValue'
  belongs_to :similar,
             class_name: 'Spree::OptionValue'

  has_one :reverse,
          class_name: 'Similarity',
          foreign_key: :similar_id,
          primary_key: :original_id,
          conditions: proc{ { original_id: self.similar.try(:id) } },
          dependent: :delete

  validates :original,
            presence: true
  validates :similar,
            presence: true
  validates :similar_id,
            uniqueness: {
              scope: :original_id
            }

  # please, use this in calls
  module Range
    VERY_CLOSE = 15
    DEFAULT    = 30
  end

  after_create unless: :reverse do
    create_reverse do |reverse|
      reverse.coefficient = coefficient
    end
  end
end
