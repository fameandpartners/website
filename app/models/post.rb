class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list, :photos, :category_id,
                  :celebrity_photos, :celebrity_photos_attributes,
                  :celebrity_photos_name

  acts_as_taggable
  has_and_belongs_to_many :celebrity_photos
  accepts_nested_attributes_for :celebrity_photos

  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User
  belongs_to :post_state
  belongs_to :category

  validates :title, :content, :category_id, presence: true
  validates :title, uniqueness: true

  def publish!
    self.post_state = PostState.find_by_title "Approved"
  end

  def unpublish!
    self.post_state = PostState.find_by_title "Pending"
  end

  private
    def upload_photos
      self.photos.each do |photo|
        self.celebrity_photos << CelebrityPhoto.create!(photo: photo)
      end
    end

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
