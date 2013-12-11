class Celebrity::StyleProfile < ActiveRecord::Base
  belongs_to :celebrity

  default_values glam: 0,
                 girly: 0,
                 classic: 0,
                 edgy: 0,
                 bohemian: 0

  attr_accessible :glam,
                  :girly,
                  :classic,
                  :edgy,
                  :bohemian,
                  :description

  validates :glam,
            :girly,
            :classic,
            :edgy,
            :bohemian,
            numericality: {
              only_integer: true,
              :greater_than_or_equal_to => 0,
              :less_than_or_equal_to => 100
            }

  validate do
    unless attributes.slice('glam', 'girly', 'classic', 'edgy', 'bohemian').values.sum.eql?(100)
      errors.add(:base, :"points_number.should_be_100")
    end
  end

  def sorted
    Hash[attributes.slice('glam', 'girly', 'classic', 'edgy', 'bohemian').sort_by(&:last).reverse]
  end

end
