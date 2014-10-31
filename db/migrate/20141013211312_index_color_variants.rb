class IndexColorVariants < ActiveRecord::Migration
  def up
    Products::ColorVariantsIndexer.index!
  end

  def down
    raise IrreversibleMigration
  end
end
