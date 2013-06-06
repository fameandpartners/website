class FashionNews < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list, :photos
  attr_accessor :photos

  acts_as_taggable
  has_many :photo_posts, as: :photo_uploaddable
  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User

  validates :title, :content, presence: true

  after_save :upload_photo

  private
    def upload_photo
      photo = [photo].flatten
      photos.each do |photo|
        self.photo_posts.create!(photo_id: CelebrityPhoto.create!(photo: photo).id)
      end
    end
end
