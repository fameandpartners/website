class MoodboardComment < ActiveRecord::Base
  belongs_to :moodboard_item
  belongs_to :user, class_name: 'Spree::User'
  attr_accessible :comment, :user_id, :moodboard_item_id

  validates :moodboard_item_id, :user_id, :comment, presence: true

  def first_name
    self.user.first_name
  end

end
