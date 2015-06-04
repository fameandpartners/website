module StyleQuiz; end

class StyleQuiz::StyleProfile
  attr_reader :answers_ids, :answers_values

  def initialize(user:, answers_ids:, answers_values:)
    @answers_ids         = answers_ids
    @answers_values      = answers_values
  end

  def create
    profile.save!
    profile
  end

  private

    def profile
      @profile ||= StyleQuiz::UserProfile.new do |profile|
        profile.answers = answers_values.merge(ids: answers_ids)
        profile.tags = tags
      end
    end

    def tags
      tags = Hash.new(0)
      StyleQuiz::Answer.where(id: answers_ids).each do |answer|
        answer.tags.each do |tag_id|
          tags[tag_id] += 1
        end
      end
      tags
    end
end
