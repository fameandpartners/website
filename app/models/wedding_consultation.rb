class WeddingConsultation < ActiveRecord::Base
  include ActiveModel::Validations
  attr_accessible :contact_method,
                  :email,
                  :first_name,
                  :last_name,
                  :should_contact,
                  :wedding_date

  validates :contact_method, presence: true, inclusion: { in: [ 'email', 'phone', 'video_chat', 'phone', 'at_home' ] }
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :should_contact, inclusion: { in: [ true, false ] }
  validates :wedding_date, presence: true
  validate :wedding_date_cannot_be_in_the_past

  def to_key
    nil
  end

  def persisted?
    false
  end

  def wedding_date_cannot_be_in_the_past
    if wedding_date.present? && wedding_date < Date.today
      errors.add(:wedding_date, "Wedding date can't be in the past")
    end
  end
end
