class Blog::CelebrityPhotoVote < ActiveRecord::Base
  UP_VOTE   = 0
  DOWN_VOTE = 1

  belongs_to :user
  belongs_to :celebrity_photo

  validates :user, :celebrity_photo, presence: true

  after_save do
    up_votes   = celebrity_photo.where(vote_type: UP_VOTE).count
    down_votes = celebrity_photo.where(vote_type: DOWN_VOTE).count
    celebrity_photo.celebrity.celebrity_photo_votes_count = up_votes - down_votes
    celebrity_photo.celebrity.save
  end
end
