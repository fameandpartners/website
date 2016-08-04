class ActivateSomeColorGroupsAsTaxons < ActiveRecord::Migration
  COLOR_GROUP_MAPPING = {
    'black'         => ['black'],
    'blues-purples' => ['pale blue', 'cobalt blue', 'purple', 'plum', 'ice blue', 'indigo', 'navy', 'lilac', 'lavender', 'dark lavender', 'aqua', 'cornflower blue', 'mauve'],
    'greens'        => ['mint', 'dark mint', 'olive', 'army green', 'dark forest', 'sage green', 'teal', 'aqua', 'light teal', 'dark teal', 'turquoise', 'apple green'],
    'grey'          => ['pale grey', 'grey', 'mid grey', 'charcoal', 'water grey', 'mushroom'],
    'metallic'      => ['silver', 'gold', 'olive shimmer', 'gold shimmer', 'pink shimmer', 'gunmetal', 'bronze'],
    'nude-tan'      => ['dark tan', 'dark nude', 'light tan', 'light nude', 'sand', 'champagne', 'nude', 'dark chocolate', 'chocolate', 'coffee'],
    'pastels'       => ['pale pink', 'pale blue', 'pale yellow', 'pale grey', 'peach', 'pastel peach'],
    'pinks'         => ['candy pink', 'pale pink', 'light pink', 'blush', 'rose', 'watermelon', 'coral', 'salmon', 'petal pink', 'pink nouveau', 'hot pink', 'magenta', 'flamingo pink', 'berry'],
    'reds'          => ['burgundy', 'red', 'cherry red', 'lipstick red', 'dark burgundy'],
    'white-ivory'   => ['white', 'ivory'],
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
