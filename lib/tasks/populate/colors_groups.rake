namespace :db do
  namespace :populate do
    task colors_groups: :environment do
      type = Spree::OptionType.find_by_name('dress-color')

      groups_attributes = {
        black:  ['black'],
        white:  ['white', 'optic white', 'ivory', 'nude', 'moonstone', 'cream and blue', 'cream'],
        blue:   ['blue', 'pale blue', 'sky blue', 'navy', 'electric blue', 'cobalt blue', 'cream and blue'],
        pink:   ['pink', 'pale pink', 'blush', 'peach', 'watermelon', 'hot pink', 'ivory and hot pink', 'hot pink and red', 'magenta', 'salmon'],
        red:    ['red', 'cherry red', 'burgundy', 'hot pink and red', 'plum'],
        green:  ['green', 'emerald green', 'forrest green', 'seafoam'],
        silver: ['silver', 'pale grey', 'silver and black', 'silver and nude', 'stone'],
        pastel: ['lilac', 'pale blue', 'pale pink', 'pale yellow', 'nude', 'moonstone', 'cream and blue', 'cream', 'blush', 'ivory', 'watermelon', 'salmon', 'seafoam', 'lavender', 'peach', 'pale grey', 'sky blue', 'dusty pink', 'aqua', 'shell']
      }

      groups_attributes.each do |group_name, color_names|
        colors = type.option_values.where('LOWER(TRIM(presentation)) IN (?)', color_names)

        Spree::OptionValuesGroup.create do |record|
          record.option_type   = type
          record.name          = group_name.to_s
          record.presentation  = group_name.to_s.titleize
          record.option_values = colors
        end
      end
    end
  end
end
