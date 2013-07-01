class Blog::CelebrityPhoto < ActiveRecord::Base
  attr_accessor :publish, :post_slug, :celebrity_slug
  attr_accessible :photo, :post_slug, :celebrity_slug, :publish

  belongs_to :celebrity, class_name: Blog::Celebrity
  belongs_to :post, class_name: Blog::Post
  belongs_to :user, class_name: Spree::User
  has_attached_file :photo
  has_many :celebrity_photo_votes

  acts_as_taggable

  validates                     :celebrity_id, presence: true
  validates                     :celebrity_slug, presence: true
  validates_attachment_presence :photo

  scope :latest, where("published_at IS NOT NULL").order("published_at desc").limit(4)
  scope :with_posts, includes(:post)

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
end
