class AddPostStates < ActiveRecord::Migration
  def self.up
    ["Pending", "In progress", "Approved"].each do |state|
      PostState.create! title: state
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
