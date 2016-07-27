class AddProcessingColumnsToBergenItemReturnProcesses < ActiveRecord::Migration
  def change
    add_column :bergen_return_item_processes, :failed, :boolean, default: false
    add_column :bergen_return_item_processes, :sentry_id, :string
  end
end
