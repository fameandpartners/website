class AddDressColours < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW dress_colours AS
        SELECT v.*
        FROM spree_option_values v JOIN spree_option_types t ON t.id = v.option_type_id
        WHERE t.name = 'dress-color'
      SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS dress_colours
    SQL
  end
end
