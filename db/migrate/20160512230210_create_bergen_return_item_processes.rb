class CreateBergenReturnItemProcesses < ActiveRecord::Migration
  def change
    create_table :bergen_return_item_processes do |t|
      t.string :aasm_state
      t.references :return_request_item

      t.timestamps
    end
  end
end
