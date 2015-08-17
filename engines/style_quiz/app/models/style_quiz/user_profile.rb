class StyleQuiz::UserProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: 'user_id'

  serialize :answer_ids,              Array
  serialize :tags,                    HashWithIndifferentAccess
  serialize :recommendated_products,  Array

  has_many :events, class_name: 'StyleQuiz::UserProfileEvent', foreign_key: 'user_profile_id', dependent: :destroy

  after_create :generate_token

  attr_accessible :email, :fullname, :birthday

  def generate_token
    if self.token.blank? && self.user.blank?
      update_column(:token, SecureRandom.hex(32))
    end
    self.token
  end

  def answers
    ::StyleQuiz::Answer.where(id: answer_ids).includes(:question)
  end

  def selected?(answer)
    return false if answer.blank?
    answer_ids.include?(answer.id)
  end

  def update_answers(answer_ids:, answer_values:, events:)
    ActiveRecord::Base.transaction do
      self.assign_attributes(answer_values)
      self.answer_ids = answer_ids
      self.events = events.map do |event_data|
        event = ::StyleQuiz::UserProfileEvent.new(
          name: event_data[:name],
          event_type: event_data[:event_type],
          date: Date.strptime(event_data[:date], I18n.t('date_format.backend'))
        )
        event.save ? event : nil
      end.compact
      self.tags = HashWithIndifferentAccess.new(StyleQuiz::Answer.get_weighted_tags(ids: answer_ids))
      self.completed_at = Time.now

      save!
    end
  end

  def completed?
    self.completed_at.present?
  end

  # it should be the same as
  # StyleQuiz::ProductsRecommendations.new(style_profile: self).product_score(product.id)
  def calculate_relevance_with(product)
    relevance = 0
    profile_tags = self.tags
    product.tags.each do |product_tag|
      if profile_tags[product_tag].present?
        tag_weight = StyleQuiz::Tag.find(product_tag).weight
        relevance += profile_tags[product_tag] * tag_weight
      end
    end
    relevance
  end

  def assign_to_user(user)
    if user.present? && self.user_id != user.id
      self.birthday ||= user.birthday
      self.fullname ||= user.fullname
      self.email    ||= user.email
      self.user_id  =   user.id
      self.token    =   nil

      self.save(validate: false)
    end
  end

  # todo: need clear algorith to find user style rates
  def user_styles
    rates = [50,20,10,10,10]
    StyleQuiz::UserStyle.all_styles.map.each_with_index do |style, index|
      style.rate = rates[index]
      style
    end
  end

  def primary_user_style
    user_styles.first
  end

  def style_attributes
    @style_attributes ||= begin
      result = {}

      question = StyleQuiz::Question.find_by_code('color-palette')
      result[:hair_color] = {
        question_id: question.id,
        values:       question.answers.where(group: 'hair', id: answer_ids).map(&:value)
      }
      result[:eyes_color] = {
        question_id: question.id,
        values:      question.answers.where(group: 'eyes', id: answer_ids).map(&:value)
      }

      question = StyleQuiz::Question.find_by_code('color-dresses')
      result[:dresses_color] = {
        question_id: question.id,
        values:      question.answers.where(id: answer_ids).map(&:name)
      }

      question = StyleQuiz::Question.find_by_code('body-size-shape')
      result[:size] = {
        question_id: question.id,
        values:      question.answers.where(id: answer_ids, group: 'size').map(&:value)
      }
      result[:shape] = {
        question_id: question.id,
        values:      question.answers.where(id: answer_ids, group: 'shape').map(&:value)
      }
      result
    end
  end

  class << self
    def read(user:, token:)
      if token.present?
        profile = StyleQuiz::UserProfile.find_by_token(token)
        if profile
          profile.assign_to_user(user)
          return profile
        end
      end

      if user.present?
        user.style_profile || user.build_style_profile
      else
        StyleQuiz::UserProfile.new
      end
    end
  end
end
