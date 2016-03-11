module Marketing
  class BodyCalculatorMeasure < ActiveRecord::Base
    EMAIL_FORMAT_REGEX = /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

    attr_accessible :email,
                    :shape,
                    :bust_circumference,
                    :under_bust_circumference,
                    :waist_circumference,
                    :hip_circumference

    validates :email, format: EMAIL_FORMAT_REGEX
    validates :email,
              :shape,
              :bust_circumference,
              :under_bust_circumference,
              :waist_circumference,
              :hip_circumference,
              presence: true
  end
end
