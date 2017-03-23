class AddHexColorsToPrettyPinkDustyRoseWarmTan < ActiveRecord::Migration
  def up
    set_hex_color( 'pretty-pink',  '#F7DBE9' )
    set_hex_color( 'dusty-rose',  '#DEAABA' )
    set_hex_color( 'warm-tan',  '#D2A788' )
    
  end

  def down
    set_hex_color( 'pretty-pink', nil )
    set_hex_color( 'dusty-rose',  nil )
    set_hex_color( 'warm-tan',  nil )
  end

  private

  def set_hex_color( color_name, hex_color )
    dress_color =Spree::OptionType.find_by_name('dress-color')    
    dc = Spree::OptionValue.find_by_name_and_option_type_id(color_name, dress_color.id)
    dc.value = hex_color
    dc.save
  end
  
end
