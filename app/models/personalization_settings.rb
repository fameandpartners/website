class PersonalizationSettings < ActiveRecord::Base
  BODY_SHAPES = %w( apple pear athletic strawberry hour_glass column petite )
  SIZES = [6, 8, 10, 12, 14, 16]

  belongs_to :user,
             class_name: 'Spree::User'

  attr_accessible :body_shape_id,
                  :height,
                  :size


  validates :body_shape_id,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: 0...BODY_SHAPES.size
            }

  validates :height,
            presence: true,
            numericality: {
              allow_blank: true,
              only_integer: true,
              greater_than_or_equal_to: 1
            }

  validates :size,
            presence: true,
            inclusion: {
              allow_blank: true,
              in: SIZES
            }


  def self.body_shapes_for_select
    BODY_SHAPES.map do |body_shape|
      [body_shape.titleize, BODY_SHAPES.index(body_shape)]
    end
  end
end
