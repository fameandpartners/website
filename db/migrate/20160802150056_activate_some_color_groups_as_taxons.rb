class ActivateSomeColorGroupsAsTaxons < ActiveRecord::Migration
  # Black - black
  # White/Ivory - white, ivory,
  # Nude/Tan - dark tan, dark nude, light tan, light nude, sand, champagne, nude, dark chocolate, chocolate, coffee,
  # Grey - pale grey, grey, mid grey, charcoal, water grey, mushroom,
  # Greens - mint, dark mint, olive, army green, dark forest, sage green, teal, aqua, light teal, dark teal, turquoise, apple green
  # Pinks - candy pink, pale pink, light pink, blush, rose, watermelon, coral, salmon, petal pink, pink nouveau, hot pink, magenta, flamingo pink, berry
  # Reds - burgundy, red, cherry red, lipstick red, dark burgundy,
  # Pastels - pale pink, pale blue, pale yellow, pale grey, peach, pastel peach,

  COLOR_GROUP_MAPPING = {
    'black'  => ['black'],
    'green'  => ['apple green', 'aqua', 'army green', 'dark forest', 'dark mint', 'dark teal', 'light teal', 'mint', 'olive', 'sage green', 'teal', 'turquoise'],
    'grey'   => ['pale grey', 'grey', 'mid grey', 'charcoal', 'water grey', 'mushroom'],
    'nude'   => ['dark tan', 'dark nude', 'light tan', 'light nude', 'sand', 'champagne', 'nude', 'dark chocolate', 'chocolate', 'coffee'],
    'pastel' => ['pale pink', 'pale blue', 'pale yellow', 'pale grey', 'peach', 'pastel peach'],
    'pink'   => ['candy pink', 'pale pink', 'light pink', 'blush', 'rose', 'watermelon', 'coral', 'salmon', 'petal pink', 'pink nouveau', 'hot pink', 'magenta', 'flamingo pink', 'berry'],
    'red'    => ['burgundy', 'red', 'cherry red', 'lipstick red', 'dark burgundy'],
    'white'  => ['white', 'ivory'],
  }

  def up
    # Deactivate current groups available as taxons
    Spree::OptionValuesGroup.for_colors.available_as_taxon.update_all(available_as_taxon: false)

    # Create option values groups which do not exist
    existent_groups    = Spree::OptionValuesGroup.for_colors.pluck(:name)
    nonexistent_groups = COLOR_GROUP_MAPPING.keys - existent_groups
    nonexistent_groups.each do |nonexistent_group_name|
      new_group                    = Spree::OptionValuesGroup.new
      new_group.option_type_id     = Spree::OptionType.color.id
      new_group.name               = nonexistent_group_name
      new_group.presentation       = nonexistent_group_name.titleize
      new_group.available_as_taxon = true
      new_group.save!
    end

    current_groups = Spree::OptionValuesGroup.for_colors.where(name: COLOR_GROUP_MAPPING.keys)

    # Associate option values to all groups
    current_groups.each do |option_value_group|
      new_color_names                  = COLOR_GROUP_MAPPING[option_value_group.name].map(&:parameterize)
      option_value_group.option_values = Spree::OptionValue.colors.where(name: new_color_names)
    end

    # Activate new available as taxons
    current_groups.update_all(available_as_taxon: true)
  end

  def down
    # NOOP. Data migration
  end
end
