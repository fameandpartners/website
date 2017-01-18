module WeddingAtelier
  class EventDress < ActiveRecord::Base
    belongs_to :product, class_name: 'Spree::Product'
    belongs_to :event
    belongs_to :user, class_name: 'Spree::User'
    belongs_to :color,
               class_name: 'Spree::OptionValue'
    belongs_to :fit,
              class_name: 'CustomisationValue'
    belongs_to :style,
               class_name: 'CustomisationValue'
    belongs_to :fabric,
               class_name: 'Spree::OptionValue'
    belongs_to :size,
              class_name: 'Spree::OptionValue'
    belongs_to :length,
               class_name: 'Spree::OptionValue'

    has_many :likes, class_name: 'WeddingAtelier::Like'

    attr_accessible :fit_id,
                    :style_id,
                    :color_id,
                    :fabric_id,
                    :size_id,
                    :length_id,
                    :user_id,
                    :product_id,
                    :height

  validates_presence_of :product, :fabric, :color, :length, :size, :height

  def images
    base_path = '/assets/wedding-atelier/dresses';
    style_name = style.try(:name) || 'S0'
    fit_name = fit.try(:name) || 'F0'
    fabric_name = fabric.try(:name) || 'HG'
    color_name = color.try(:name) || 'Champagne'
    length_name = length.try(:name) || 'AK'
    file_name = [product.sku, fabric_name, color_name, style_name, fit_name, length_name].join('-').upcase
    %w(FRONT BACK).map do |pov|
      {
        thumbnail: "#{base_path}/180x260/#{file_name}-#{pov}.jpg",
        moodboard: "#{base_path}/280x404/#{file_name}-#{pov}.jpg",
        normal: "#{base_path}/900x1300/#{file_name}-#{pov}.jpg",
        large: "#{base_path}/1800x2600/#{file_name}-#{pov}.jpg"
      }
    end
  end

  def liked_by?(user)
    likes.find_by_user_id(user.id).present?
  end

  def like_by(user)
    likes.create(user_id: user.id)
  end

  def dislike_by(user)
    likes.find_by_user_id(user.id).destroy
  end

  end
end
