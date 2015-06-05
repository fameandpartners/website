class StyleQuiz::UserProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: 'user_id'

  serialize :answers, Hash
  serialize :tags,    Hash
  serialize :recommendated_products, Array

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

  def generate_token
    if self.token.blank?
      update_column(:token, SecureRandom.hex(32))
    end
    self.token
  end
end
