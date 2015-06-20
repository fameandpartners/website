class StyleQuiz::Answer < ActiveRecord::Base
  belongs_to :question, class_name: 'StyleQuiz::Question', foreign_key: 'question_id'

  serialize :tags, Array

  class << self
    def get_weighted_tags(ids:)
      tags = Hash.new(0)
      StyleQuiz::Answer.where(id: ids).each do |answer|
        answer.tags.each do |tag_id|
          tags[tag_id] += 1
        end
      end
      tags
    end
  end
end
