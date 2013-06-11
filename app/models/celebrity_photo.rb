class CelebrityPhoto < ActiveRecord::Base
  attr_accessible :event_date, :event_name, :photo, :name, :tag_list, :celebrity_name
  attr_accessor :celebrity_name

  acts_as_taggable
  has_attached_file :photo, :styles => { :list => "375x269>", :thumb => "75x108>" }

  belongs_to :celebrity
  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User
  belongs_to :post_state
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :red_carpet_events
  has_many :photo_posts

  validates_attachment_presence :photo
  validates :celebrity_name, presence: true
  before_validation :create_or_append_celebrity

  def title
    celebrity ? celebrity.name : nil
  end

  private
    def create_or_append_celebrity
      if celebrity_name
        self.celebrity = Celebrity.where(name: celebrity_name).first_or_create
      end
    end
end
