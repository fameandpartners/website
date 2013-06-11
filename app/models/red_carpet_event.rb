class RedCarpetEvent < ActiveRecord::Base
  attr_accessible :name, :short_name, :latitude, :longitude, :content, :tag_list, :photos, :event_date, :location
  attr_accessor :photos

  acts_as_taggable
  has_many :celebrity_photos, as: :photo_uploaddable

  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User
  belongs_to :post_state

  validates :name, :latitude, :longitude, :event_date, presence: true

  def title
    name
  end

  def publish!
    self.post_state = PostState.find_by_title "Approved"
  end

  def unpublish!
    self.post_state = PostState.find_by_title "Pending"
  end

  after_save :upload_photos

  private
    def upload_photos
      self.photos.each do |photo|
        self.celebrity_photos << CelebrityPhoto.create!(photo: photo)
      end
    end
end
