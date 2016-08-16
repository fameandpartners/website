class ActivateSomeColorGroupsAsTaxons < ActiveRecord::Migration
  COLOR_GROUP_MAPPING = {
    'black'       => ['black'],
    'blue-purple' => ['pale blue', 'cobalt blue', 'purple', 'plum', 'ice blue', 'indigo', 'navy', 'lilac', 'lavender', 'dark lavender', 'aqua', 'cornflower blue', 'mauve'],
    'green'       => ['mint', 'dark mint', 'olive', 'army green', 'dark forest', 'sage green', 'teal', 'aqua', 'light teal', 'dark teal', 'turquoise', 'apple green'],
    'grey'        => ['pale grey', 'grey', 'mid grey', 'charcoal', 'water grey', 'mushroom'],
    'metallic'    => ['silver', 'gold', 'olive shimmer', 'gold shimmer', 'pink shimmer', 'gunmetal', 'bronze'],
    'nude-tan'    => ['dark tan', 'dark nude', 'light tan', 'light nude', 'sand', 'champagne', 'nude', 'dark chocolate', 'chocolate', 'coffee'],
    'pastel'      => ['pale pink', 'pale blue', 'pale yellow', 'pale grey', 'peach', 'pastel peach'],
    'pink'        => ['candy pink', 'pale pink', 'light pink', 'blush', 'rose', 'watermelon', 'coral', 'salmon', 'petal pink', 'pink nouveau', 'hot pink', 'magenta', 'flamingo pink', 'berry'],
    'red'         => ['burgundy', 'red', 'cherry red', 'lipstick red', 'dark burgundy'],
    'white-ivory' => ['white', 'ivory'],
  }

  REVOLUTION_PAGES_INFO = {
    'black'       => {
      meta_description: 'Find a black dress for any occasion and style from prom to maxi’s. Transform and customize your look from day-time office to night-time chic.',
      meta_title:       'Black dresses and gowns',
      subtitle:         'The black dress has taken a new turn. A timeless item in your wardrobe perfect for every occasion. Any style, we’ve got you covered.',
      title:            'Black Dresses',
    },
    'blue-purple' => {
      title:            'Blue Dresses',
      subtitle:         'Feeling blue? Change it up in bold & daring shades of teal, turquoise or navy dresses and add an unexpected turn to your wardrobe.',
      meta_title:       'Blue dresses | Shop our trending range',
      meta_description: 'Fame & Partners offers a wide variety of blue dresses. From Icy to baby blue, we have it all.',
    },
    'green'       => {
      title:            'Green Dresses',
      subtitle:         "A look that's on-the-money.",
      meta_title:       'Green Dresses - Shop Online',
      meta_description: "Make 'em green with envy in our collection of green gowns, cocktail dresses, two-piece sets and slips, all made-to-order and guaranteed to fit.",
    },
    'grey'        => {
      title:            'Grey Dresses',
      subtitle:         "It's good to go grey.",
      meta_title:       'Grey Dresses - Shop Online',
      meta_description: 'Ready to go grey? Search our shoppable collection of grey slip dresses, grey gowns, grey cocktail dresses and more, all customizable and made-to-order.',
    },
    'metallic'    => {
      title:            'Metallic dresses',
      subtitle:         'Heavy Metal',
      meta_title:       'Metallic dress online',
      meta_description: 'Shop gold, silver, rose gold and black metallic dresses in sequins and shiny silks in fully customizable styles.',

    },
    'nude-tan'    => {
      title:            'Nude Dresses',
      subtitle:         'Stripped-down style',
      meta_title:       'Nude Dresses and Tan Dresses - Shop Online',
      meta_description: 'Shop the new Naked Dress. Our collection of nude dresses and tan dresses is customizable, made-to-order and guaranteed to fit.',
    },
    'pastel'      => {
      title:            'Pastel Dresses',
      subtitle:         'Indulge in sweet treats, in the prettiest way possible. A Pastel dress will take you from girly to glam and across all seasons in a click of a button.',
      meta_title:       'Beautiful pastel dresses',
      meta_description: 'Change it up in pastel hues and take on a fresh look inspired straight from the latest runway trends. Find your own dress style & add  these treats to your wardrobe.',
    },
    'pink'        => {
      title:            'Pink Dresses',
      subtitle:         'Candy and lolly pops? Only pink frocks! meh! Only pink dresses. Whether you’re tuning into your feminine or fierce side, pink will deliver.',
      meta_title:       'Pink dresses',
      meta_description: 'Embrace girl power in every shade of pink. We’ve got you covered girl. Customise these killer dresses into the style you always wished for!',
    },
    'red'         => {
      title:            'Red Dresses',
      subtitle:         'Look red haute in statement-making shades.',
      meta_title:       'Red Dresses',
      meta_description: 'Look red haute in statement-making shades.',
    },
    'white-ivory' => {
      title:            'White/Ivory Dresses',
      subtitle:         'Clean cuts and pristine whites make for a refreshing look. Achieve effortless style in sleek white dresses, with a modern twist.',
      meta_title:       'White dresses online',
      meta_description: 'Made to order white dresses. Perfect for every occasion .Whether a bride or a fashion diva, white is a class and a wardrobe must.',
    },
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

    # Create Revolution Pages for meta information
    REVOLUTION_PAGES_INFO.map do |color_name, page_info|
      page = Revolution::Page.where(path: "/dresses/#{color_name}").first
      if page.nil?
        new_page               = Revolution::Page.new
        new_page.path          = "/dresses/#{color_name}"
        new_page.template_path = '/products/collections/show'
        new_page.publish_from  = 3.days.ago
        new_page.save!

        new_page.translations.create!(
          locale:           Revolution::Translation::DEFAULT_LOCALE,
          heading:          page_info[:title],
          meta_description: page_info[:meta_description],
          sub_heading:      page_info[:subtitle],
          title:            page_info[:meta_title]
        )
      end
    end
  end

  def down
    # NOOP. Data migration
  end
end
