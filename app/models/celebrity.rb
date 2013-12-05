class Celebrity < ActiveRecord::Base
  has_and_belongs_to_many :products,
                          class_name: 'Spree::Product'
  has_one :style_profile
  has_many :images
  has_one :primary_image,
          class_name: 'Image',
          conditions: {
            is_primary: true
          }
  has_many :secondary_images,
           class_name: 'Image',
           conditions: {
             is_primary: false
           }

  attr_accessible :first_name,
                  :last_name,
                  :slug,
                  :product_ids,
                  :is_published

  validates :first_name,
            presence: true

  validates :slug,
            presence: true
  validates :slug,
            uniqueness: true

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end
end
