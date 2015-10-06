class DeleteMasterpass < ActiveRecord::Migration
  def up
    execute "delete from spree_payments where source_type like '%Masterpass%';"
  end

  def down
  end
end
