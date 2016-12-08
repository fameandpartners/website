module WeddingAtelier
  class EventDress < ActiveRecord::Base
    belongs_to :product
    belongs_to :event
    belongs_to :user
    belongs_to :color,
               class_name: 'Spree::OptionValue'
    belongs_to :fit,
              class_name: 'Spree::OptionValue'
    belongs_to :style,
               class_name: 'Spree::OptionValue'
    belongs_to :fabric,
               class_name: 'Spree::OptionValue'
    belongs_to :size,
              class_name: 'Spree::OptionValue'
    belongs_to :length,
               class_name: 'Spree::OptionValue'

    attr_accessible :fit_id,
                    :style_id,
                    :color_id,
                    :fabric_id,
                    :size_id,
                    :length_id

  end
end
