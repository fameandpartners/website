class PhotoPost < ActiveRecord::Base
  attr_accessible :photo_id, :photo_uploaddable_id, :photo_uploaddable_type

  belongs_to :photo_uploaddable, polymorphic: true
  has_one :photo

end
