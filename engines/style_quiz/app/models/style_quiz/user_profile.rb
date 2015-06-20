class StyleQuiz::UserProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: 'user_id'

  serialize :answers, Hash
  serialize :tags,    Hash
  serialize :recommendated_products, Array

  has_many :events, class_name: 'StyleQuiz::UserProfileEvent', foreign_key: 'user_profile_id', dependent: :destroy

  after_create :generate_token

  def generate_token
    if self.token.blank?
      update_column(:token, SecureRandom.hex(32))
    end
    self.token
  end

  def selected?(answer)
    return false if answer.blank?
    self.answers['ids'].include?(answer.id.to_s)
  end

  def update_answers(answers_ids:, answers_values:, events:)
    ActiveRecord::Base.transaction do
      self.answers = answers_values.merge( ids: answers_ids )
      self.events = events.map{|event_data| ::StyleQuiz::UserProfileEvent.new(event_data)}
      self.tags = StyleQuiz::Answer.get_weighted_tags(ids: answers_ids)
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
    if user.present? && profile.user_id != user.id
      profile.update_column(:user_id, user.id)
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
