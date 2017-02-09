module Forms
  class WeddingPlanning < Reform::Form
    property :first_name
    property :last_name
    property :wedding_date
    property :email
    property :should_contact
    property :should_receive_trend_updates

    validates :first_name,
              :last_name,
              presence: true

    validates :email,
              format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }

    validate do
      wedding_date_cannot_be_in_the_past
    end

    def wedding_date_cannot_be_in_the_past
      if wedding_date.present? && Date.strptime(wedding_date, '%m/%d/%Y') < Date.today
        errors.add(:wedding_date, "Wedding date can't be in the past")
      end
    end
  end
end
