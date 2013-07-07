class Blog::CelebrityPhoto < ActiveRecord::Base
  attr_accessible :photo

  belongs_to :celebrity, class_name: Blog::Celebrity
  belongs_to :post, class_name: Blog::Post
  belongs_to :user, class_name: Spree::User
  has_attached_file :photo, styles: { preview: "576x770#", small: "250x375#"}
  has_many :celebrity_photo_votes

  acts_as_taggable

  validates_attachment_presence :photo

  scope :assigned, where('celebrity_id IS NOT NULL')
  scope :with_posts, includes(:post)

  before_create :randomize_file_name

  class << self
    def latest
      includes(:celebrity, :post).where("celebrity_id IS NOT NULL").limit(4)
    end
  end

  def like!(user)
    vote = find_or_build_vote(user)
    vote.user_id = user.id
    vote.vote_type = CelebrityPhotoVote::UP_VOTE
    vote.save
  end

  def dislike!(user)
    vote = find_or_build_vote(user)
    vote.user_id = user.id
    vote.vote_type = CelebrityPhotoVote::DOWN_VOTE
    vote.save
  end

  def find_or_build_vote(user)
    celebrity_photo_votes.where(user_id: user.id).first || celebrity_photo_votes.build
  end

  def publish
    published_at.present?
  end

  def created_at_formatted
    #"Wednesday, May 15th, 2013"
    created_at.strftime("%A, %b #{created_at.day.ordinalize}, %Y")
  end

  def post_slug
    if post.present?
      post.slug
    end
  end

  def celebrity_slug
    if celebrity.present?
      celebrity.slug
    end
  end

  def state
    if published_at?
      'published'
    else
      'not published'
    end
  end

  def to_jq_upload
    {
      "name" => read_attribute(:photo_file_name),
      "size" => read_attribute(:photo_file_size),
      "thumbnail_url" => photo.url(:small),
      "url" => photo.url,
      "delete_url" => "/admin/blog/celebrity_photos/#{self.id}",
      "delete_type" => "DELETE",
      "id" => self.id,
      "celebrity_id" => celebrity.try(:id)
    }
  end

  private

  def randomize_file_name
    extension = File.extname(photo_file_name).downcase
    self.photo.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end
end
