class ProductReservation < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user,     class_name: 'Spree::User',    foreign_key: :user_id
  belongs_to :product,  class_name: 'Spree::Product', foreign_key: :product_id

  validates :user,    presence: true
  validates :product, presence: true
  validates :school_name, :formal_name, presence: true

  validates :school_year, presence: true, format: /^20\d{2}$/

  attr_accessible :school_name, :formal_name, :school_year, :color, :product_id, :user_id

  after_create :notify_team

  def notify_team
    ProductReservationsMailer.new_reservation(self).deliver
  end
end
