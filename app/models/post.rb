class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list, :photo
  attr_accessor :photo

  acts_as_taggable
  mount_uploader :photo, PhotoUploader
  has_many :photo_posts, as: :photo_uploaddable

  def photo_will_change!
    true
  end

  after_save :upload_photo

  private
    def upload_photo
      photo_post = self.photo_posts.create!(photo_id: CelebrityPhoto.create!(photo: photo).id)
    end
end
