class WeddingConsultation < ActiveRecord::Base
  include ActiveModel::Validations
  attr_accessible :full_name,
                  :email,
                  :phone,
                  :preferred_time,
                  :session_type,
                  :should_contact,
                  :timezone
                  :wedding_date

  validates :full_name, presence: true
  validates :email, format: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, presence: true
  validates :session_type, presence: true, inclusion: { in: [ 'Email', 'Text', 'Video Chat', 'Phone', 'At Home' ] }
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
