class ChangeFloatFieldsTypeToIntegerInAnswers < ActiveRecord::Migration
  def up
    change_table :answers do |t|
      t.change :glam, :integer
      t.change :girly, :integer
      t.change :classic, :integer
      t.change :edgy, :integer
      t.change :bohemian, :integer
      t.change :sexiness, :integer
      t.change :fashionability, :integer
    end
  end

  def down
    change_table :answers do |t|
      t.change :glam, :float
      t.change :girly, :float
      t.change :classic, :float
      t.change :edgy, :float
      t.change :bohemian, :float
      t.change :sexiness, :float
      t.change :fashionability, :float
    end
  end
end
