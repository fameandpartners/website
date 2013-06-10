class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list, :photos

  has_and_belongs_to_many :photos
  accepts_nested_attributes_for :photos

  acts_as_taggable
  mount_uploader :photo, PhotoUploader
  has_many :photo_posts, as: :photo_uploaddable
  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User
  belongs_to :post_state

  validates :title, :content, presence: true

  def photo_will_change!
    true
  end

  after_save :upload_photo

  private

  def upload_photo
    photo_post = self.photo_posts.create!(photo_id: CelebrityPhoto.create!(photo: photo).id)
  end
end
