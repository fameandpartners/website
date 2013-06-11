class PhotoPost < ActiveRecord::Base
  attr_accessible :photo_id, :photo_uploaddable_id, :photo_uploaddable_type, :category_id

  belongs_to :photo_uploaddable, polymorphic: true
  belongs_to :celebrity_photo, foreign_key: :photo_id
  belongs_to :post_state
  belongs_to :category

  scope :get, ->(resource) { where(photo_uploaddable_type: resource.to_s.singularize.classify) }
end
