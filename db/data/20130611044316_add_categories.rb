class AddCategories < ActiveRecord::Migration
  def self.up
    ["Posts", "Fashion News", "Prom Tips", "Style Tips"].each do |category|
      Category.create! title: category
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
