class Blog::Author < ActiveRecord::Base
  attr_accessible :description, :first_name, :last_name, :photo, :slug

  belongs_to :user, class_name: Spree::User
  has_many :posts, class_name: Blog::Post
  has_attached_file :photo

  validates :first_name, :last_name, :slug, presence: true
  validates_attachment_presence :photo

  def fullname
    [first_name, last_name].join(' ')
  end
end
