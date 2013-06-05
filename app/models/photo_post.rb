class PhotoPost < ActiveRecord::Base
  attr_accessible :photo_id, :photo_uploaddable_id, :photo_uploaddable_type

  belongs_to :photo_uploaddable, polymorphic: true

  def photo_url
    CelebrityPhoto.find_by_id(self.photo_id).photo
  end
end
