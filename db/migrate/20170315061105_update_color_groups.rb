class UpdateColorGroups < ActiveRecord::Migration
  def up
    update_color_group('print', %w(art-soul micro-spot watercolour-camo rosewater-floral cobalt-crush-floral micro-star evening-bloom grand-lily mystic-floral midnight-floral gypsy-queen bird-of-paradise midnight-reptile ornate-dusk-floral looking-glass candy-floral pink-and-white-gingham midnight-daisy black-and-white-gingham) )
    update_color_group('black', %w( black ) )
    update_color_group('white-ivory', %w( white ivory ) )
    update_color_group('nude-tan', %w( dark-tan dark-nude light-nude sand champagne nude  dark-chocolate chocolate coffee warm-tan taupe ochre tan ) )
    update_color_group('grey', %w( pale-grey grey mid-grey charcoal water-grey winter-grey grey-marle) )
    update_color_group('blue', %w( pale-blue cobalt-blue ice-blue indigo navy aqua cornflower-blue azure chambray pale-blue-cotton-stripe indigo-cotton-stripe ) )
    update_color_group('purple', %w(lilac lavender dark-lavender mauve plum purple) )
    update_color_group('green', %w( mint dark-mint olive army-green dark-forest sage-green teal aqua light-teal dark-teal turquoise apple-green light-khaki olive-shimmer irridescent-green forest-green green ) )
    update_color_group('pink', %w( candy-pink pale-pink light-pink blush rose watermelon coral salmon petal-pink pink-nouveau hot-pink magenta flamingo-pink berry pretty-pink pink dusk mushroom dusty-mushroom) )
    update_color_group('red', %w(burgundy red cherry-red lipstick-red dark-burgundy ) )
    update_color_group('pastel', %w(pale-pink pale-blue pale-yellow pale-grey peach pastel-peach ) )
    update_color_group('metallic', %w(silver gold olive-shimmer gold-shimmer pink-shimmer gunmetal bronze dark-gold pale-silver) )
    
  end

  def down
    update_color_group('black', %w( black ) )
    update_color_group('white-ivory', %w( ivory white ) )
    update_color_group('nude-tan', %w( nude dark-nude dark-chocolate light-nude coffee dark-tan chocolate sand champagne) )
    update_color_group('grey', %w( mid-grey grey charcoal mushroom water-grey pale-grey) )
    update_color_group('blue', %w( blue sky-blue pale-blue cobalt-blue electric-blue navy cream-and-blue ) )
    update_color_group('purple', %w( lavender lilac purple plum ) )
    update_color_group('green', %w( sage-green aqua olive dark-forest army-green apple-green dark-mint light-teal dark-teal turquoise mint teal ) )
    update_color_group('pink', %w( blush candy-pink coral light-pink flamingo-pink petal-pink watermelon hot-pink rose salmon magenta berry pale-pink pink-nouveau) )
    update_color_group('red', %w(burgundy red lipstick-red dark-burgundy cherry-red) )
    update_color_group('pastel', %w(pale-yellow pale-blue pastel-peach peach pale-pink pale-yellow pale-grey) )
    update_color_group('metallic', %w(gold bronze silver gunmetal pink-shimmer gold-shimmer olive-shimmer) )
    
  end

  private
  def color(color_name)
    Spree::OptionType.color.option_values.find_by_name( color_name )
  end

  def update_color_group( group_name, color_name_array )
    group = Spree::OptionType.color.option_values_groups.includes(:option_values).find_by_name( group_name )
    group.option_values = color_name_array.collect { |name| color(name) }
    group.save
  end
  
end
