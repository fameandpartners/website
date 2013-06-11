class RedCarpetEvent < ActiveRecord::Base
  attr_accessible :name, :short_name, :latitude, :longitude, :content, :tag_list,
                  :event_date, :location, :celebrity_photos, :celebrity_photos_attributes,
                  :celebrity_photos_name
  attr_accessor :celebrity_name

  acts_as_taggable

  has_and_belongs_to_many :celebrity_photos
  accepts_nested_attributes_for :celebrity_photos

  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User
  belongs_to :post_state

  validates :name, :latitude, :longitude, :event_date, presence: true
  validates :name, uniqueness: true

  def title
    name
  end

  def publish!
    self.post_state = PostState.find_by_title "Approved"
    save!
  end

  def unpublish!
    self.post_state = PostState.find_by_title "Pending"
    save!
  end
end
