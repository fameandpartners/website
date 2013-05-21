class CustomDress < ActiveRecord::Base
  COLORS = %w(Pink Green Gold Purple Orange Blue)

  attr_accessible :description,
                  :phone_number,
                  :bust,
                  :waist,
                  :hips,
                  :hollow,
                  :color

  belongs_to :spree_user, :class_name => 'Spree::User'
  has_many :custom_dress_images

  validates :phone_number,
            :bust,
            :waist,
            :hips,
            :hollow,
            :color,
            :presence => true

  validates :color,
            :inclusion => {
              :allow_blank => true,
              :in => COLORS
            }

  after_create :send_emails

  private

  def send_emails
    Spree::UserMailer.custom_dress_created(self).deliver
    Spree::AdminMailer.custom_dress_created(self).deliver
  end
end
