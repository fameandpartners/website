class AddStepToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :step, :integer
  end
end
