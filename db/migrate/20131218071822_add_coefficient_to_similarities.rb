class AddCoefficientToSimilarities < ActiveRecord::Migration
  def change
    add_column :similarities, :coefficient, :float
  end
end
