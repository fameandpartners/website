module Forms
  class WeddingPlanning < Reform::Form
    property :first_name, virtual: true
    property :last_name, virtual: true
    property :should_receive_trend_updates, virtual: true
    property :should_contact, virtual: true
    property :wedding_date, virtual: true
    property :email, virtual: true

    validate do
      wedding_date_cannot_be_in_the_past
    end

    validates :first_name,
              presence: true

    validates :last_name,
              presence: true

    validates :should_receive_trend_updates,
              presence: true

    validates :should_contact,
              presence: true,
              inclusion: { in: [ true, false ] }

    validates :email,
              format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i }

    def wedding_date_cannot_be_in_the_past
      if wedding_date.present? && Date.strptime(wedding_date, '%m/%d/%Y') < Date.today
        errors.add(:wedding_date, "Wedding date can't be in the past")
      end
    end

  end
end
