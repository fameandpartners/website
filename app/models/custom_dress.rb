class CustomDress < ActiveRecord::Base
  COLORS = %w(Pink Green Gold Purple Orange Blue)

  attr_accessible :first_name,
                  :last_name,
                  :email,
                  :description,
                  :bust,
                  :waist,
                  :hips,
                  :hollow,
                  :color

  has_many :custom_dress_images

  validates :first_name,
            :last_name,
            :email,
            :bust,
            :waist,
            :hips,
            :hollow,
            :color,
            :presence => true

  validates :email,
            :format => {
              :allow_blank => true,
              :with => Devise.email_regexp
            }

  validates :color,
            :inclusion => {
              :allow_blank => true,
              :in => COLORS
            }
end
