class MoodboardCommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :comment
  has_one :moodboard_item
end
