class CelebrityPhoto < ActiveRecord::Base
  attr_accessible :event_date, :event_name, :photo, :celebrity_name, :tag_list
  attr_accessor :celebrity_name

  acts_as_taggable
  has_attached_file :photo, :styles => { :list => "375x269>", :thumb => "75x108>" }

  belongs_to :celebrity
  belongs_to :user, foreign_key: 'user_id', class_name: Spree::User

  validates_attachment_presence :photo
  before_save :create_or_append_celebrity

  def celebrity_name
    celebrity ? celebrity.name : nil
  end

  private
    def create_or_append_celebrity
      if celebrity_name
        self.celebrity = Celebrity.where(name: celebrity_name).first_or_create
      end
    end
end
