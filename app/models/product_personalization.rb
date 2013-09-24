class ProductPersonalization < ActiveRecord::Base
  belongs_to :user,
             class_name: 'Spree::User'
  belongs_to :line_item,
             class_name: 'Spree::LineItem'
  has_one    :order,
             through: :line_item,
             class_name: 'Spree::Order'
  belongs_to :variant,
             class_name: 'Spree::Variant'
  has_one    :product,
             through: :variant,
             class_name: 'Spree::Product'

  attr_accessible :add_beads_or_sequins,
                  :change_color,
                  :change_fabric_type,
                  :change_hem_length,
                  :change_neck_line,
                  :comments,
                  :merge_styles,
                  :user_email,
                  :user_first_name,
                  :user_last_name,
                  :variant_id

  validates :user_first_name,
            :user_last_name,
            :user_email,
            presence: {
              unless: lambda{ user.present? }
            }
  validates :user_email,
            format: {
              allow_blank: true,
              with: Devise.email_regexp
            }
  validates :variant,
            presence: true
  validate do
    if variant && variant.in_sale?
      errors.add(:product, 'in sale. It can not be customized.')
    end
  end

  after_create do
    Spree::AdminMailer.product_personalized(self).deliver
  end

  def user_full_name
    "#{user_first_name} #{user_last_name}"
  end

  def user_first_name
    user.present? ? user.first_name : self[:user_first_name]
  end

  def user_last_name
    user.present? ? user.last_name : self[:user_last_name]
  end

  def user_email
    user.present? ? user.email : self[:user_email]
  end
end
