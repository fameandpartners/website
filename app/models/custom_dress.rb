class CustomDress < ActiveRecord::Base
  GIRL_SIZES = {
    'Girls 0'  => 'G0',
    'Girls 2'  => 'G2',
    'Girls 4'  => 'G4',
    'Girls 6'  => 'G6',
    'Girls 8'  => 'G8',
    'Girls 10' => 'G10',
    'Girls 12' => 'G12',
    'Girls 14' => 'G14'
  }

  LADY_SIZES = {
    'Ladies 0'  => 'L0',
    'Ladies 2'  => 'L2',
    'Ladies 4'  => 'L4',
    'Ladies 6'  => 'L6',
    'Ladies 8'  => 'L8',
    'Ladies 10' => 'L10',
    'Ladies 12' => 'L12',
    'Ladies 14' => 'L14'
  }

  SIZES = GIRL_SIZES.merge(LADY_SIZES)

  attr_accessible :phone_number,
                  :required_at,
                  :school_name,
                  :size,
                  :color,
                  :description

  belongs_to :spree_user,
             :class_name => 'Spree::User'
  has_many :custom_dress_images

  validates :phone_number,
            :required_at,
            :size,
            :color,
            :presence => true

  validates :description,
            :presence => true,
            :unless => :new_record?,
            :if => :ghost?

  validates :size,
            :inclusion => {
              :allow_blank => true,
              :in => SIZES.values
            }

  validates :color,
            :format => {
              :allow_blank => true,
              :with => /^#(?:[0-9a-fA-F]{3}){1,2}$/
            }

  validates :school_name,
            :presence => {
              :if => proc{ spree_user.sign_up_reason.eql?('workshop') }
            }

  def self.find_ghost_for_user_by_id!(user_id, id)
    CustomDress.find_by_ghost_and_spree_user_id_and_id!(true, user_id, id)
  end
end
