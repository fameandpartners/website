class Blog::PromoBanner < ActiveRecord::Base
  attr_accessible :title, :url, :position, :published, :photo, :description

  belongs_to :user, class_name: Spree::User
  has_attached_file :photo

  validates :title, :url, :user_id, presence: true
  validates_attachment_presence :photo, styles: { original: "1078x434#", small: "250x375#"}

  scope :published, where(published: true)

  def state
    if published?
      'published'
    else
      'not published'
    end
  end
end
