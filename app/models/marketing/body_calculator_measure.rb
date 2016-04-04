module Marketing
  class BodyCalculatorMeasure < ActiveRecord::Base
    EMAIL_FORMAT_REGEX = /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

    attr_accessible :bust_circumference,
                    :hip_circumference,
                    :shape,
                    :size,
                    :under_bust_circumference,
                    :waist_circumference,
                    :email,
                    :unit

    validates :email, format: EMAIL_FORMAT_REGEX
    validates :bust_circumference,
              :hip_circumference,
              :shape,
              :size,
              :under_bust_circumference,
              :waist_circumference,
              :email,
              :unit,
              presence: true
  end
end
