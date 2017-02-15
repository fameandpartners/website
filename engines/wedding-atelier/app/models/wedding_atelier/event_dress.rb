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
               class_name: 'CustomisationValue'
    belongs_to :size,
               class_name: 'Spree::OptionValue'
    belongs_to :length,
               class_name: 'CustomisationValue'

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

    # TODO: this is a "primitive obsession" code smell. Since images for "Event Dresses" are dynamically calculated, they should have their own class
    def images
      base_path = "#{ENV['RAILS_ASSET_HOST']}/wedding-atelier/dresses"
      style_name = style.try(:name) || 'S0'
      fit_name = fit.try(:name) || 'F0'
      fabric_name = fabric.try(:name) || 'HG'
      color_name = color.try(:name) || 'Champagne'
      length_name = length.try(:name) || 'AK'
      file_name = [product.sku, 'HG', color_name, style_name, fit_name, length_name].join('-').upcase
      real_image_name = [product.sku, fabric_name, color_name, 'S0', 'F0', 'AK'].join('-').upcase
      # File name is wrong for all bright Turquoise colors,
      # have to do this instead of changing every single file.
      color_name = 'bright-turquise' if color_name === 'bright-turquoise'
      images = {
        real: {
          thumbnails: [
            "#{base_path}/350x500/#{real_image_name}-FRONT.jpg",
            "#{base_path}/350x500/#{real_image_name}-1.jpg",
            "#{base_path}/350x500/#{real_image_name}-2.jpg",
            "#{base_path}/350x500/#{real_image_name}-3.jpg",
            "#{base_path}/350x500/#{real_image_name}-4.jpg"
          ],
          large: [
            "#{base_path}/1440x1310/#{real_image_name}-FRONT.jpg",
            "#{base_path}/1440x1310/#{real_image_name}-1.jpg",
            "#{base_path}/1440x1310/#{real_image_name}-2.jpg",
            "#{base_path}/1440x1310/#{real_image_name}-3.jpg",
            "#{base_path}/1440x1310/#{real_image_name}-4.jpg"
          ]
        }
      }
      %w(FRONT BACK).each do |point_of_view|
        images[point_of_view.downcase.to_sym] = {
          thumbnail: {
            white: "#{base_path}/180x260/white/#{file_name}-#{point_of_view}.jpg",
            grey: "#{base_path}/180x260/grey/#{file_name}-#{point_of_view}.jpg",

          },
          moodboard: "#{base_path}/280x404/#{file_name}-#{point_of_view}.jpg",
          normal: "#{base_path}/900x1300/#{file_name}-#{point_of_view}.jpg",
          large: "#{base_path}/1800x2600/#{file_name}-#{point_of_view}.jpg"
        }
      end
      images
    end

    def liked_by?(user)
      likes.exists?(user_id: user&.id)
    end

    def like_by(user)
      likes.create(user_id: user.id)
    end

    def dislike_by(user)
      likes.find_by_user_id(user.id).destroy
    end

    def customizations_ids
      [length_id, fabric_id, fit_id, style_id].compact
    end
  end
end
