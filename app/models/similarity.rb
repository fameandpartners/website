class Similarity < ActiveRecord::Base
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

  after_create :create_reverse, unless: :reverse
end
