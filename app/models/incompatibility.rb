class Incompatibility < ActiveRecord::Base
  belongs_to :original,
             class_name: 'CustomisationValue'
  belongs_to :incompatible,
             class_name: 'CustomisationValue'

  has_one :reverse,
          class_name: 'Incompatibility',
          foreign_key: :incompatible_id,
          primary_key: :original_id,
          conditions: proc{ { original_id: self.incompatible.try(:id) } },
          dependent: :delete

  validates :original,
            presence: true
  validates :incompatible,
            presence: true
  validates :incompatible_id,
            uniqueness: {
              scope: :original_id
            }

  after_create unless: :reverse do
    create_reverse
  end

  after_destroy if: :reverse do
    reverse.destroy
  end
end
