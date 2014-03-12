class AnswerTaxon < ActiveRecord::Base
  belongs_to :answer
  belongs_to :taxon,
             class_name: 'Spree::Taxon'

  validates :answer,
            presence: true
  validates :taxon,
            presence: true

  validates :taxon_id,
            uniqueness: {
              scope: :answer_id
            }
end