class AddPopulateToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :populate, :string
  end
end
