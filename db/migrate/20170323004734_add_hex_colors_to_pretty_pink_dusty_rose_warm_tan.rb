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
    Spree::OptionValue.colors.where(name: color_name).update_all(value: hex_color)    
  end
  
end
