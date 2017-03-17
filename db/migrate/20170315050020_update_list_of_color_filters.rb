class UpdateListOfColorFilters < ActiveRecord::Migration
  def up
    create_option_value_group( 'print' )
    delete_option_value_group( 'silver' )
    delete_option_value_group( 'yellow' )
    delete_option_value_group( 'nude' )
    delete_option_value_group( 'white' )
    delete_option_value_group( 'blue-purple' )
  end

  def down
    delete_option_value_group( 'print' )
    create_option_value_group( 'silver' )
    create_option_value_group( 'yellow' )
    create_option_value_group( 'nude' )
    create_option_value_group( 'white' )
    create_option_value_group( 'blue-purple' )    
  end

  private
  def create_option_value_group( name )
    group = Spree::OptionValuesGroup.new
    group.option_type = Spree::OptionType.find_by_name( 'dress-color' )
    group.name = name
    group.presentation = name.titlecase
    group.available_as_taxon = true
    group.save
  end

  def delete_option_value_group( name )
    group = Spree::OptionValuesGroup.find_by_name( name )
    if( group.present? )
      group.delete
    else
      false
    end
  end
  
  
end
