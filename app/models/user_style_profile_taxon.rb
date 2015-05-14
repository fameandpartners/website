class UserStyleProfileTaxon < ActiveRecord::Base
#  belongs_to :user_style_profile
#  belongs_to :taxon,
#             class_name: 'Spree::Taxon'
#
#
#  validates :user_style_profile,
#            presence: true
#  validates :taxon,
#            presence: true
#
#  validates :taxon_id,
#            uniqueness: {
#              scope: :user_style_profile_id
#            }
#  validates :capacity,
#            numericality: {
#              only_integer: true,
#              greater_than: 0
#            }
end
