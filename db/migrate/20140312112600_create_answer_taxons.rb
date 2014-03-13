class CreateAnswerTaxons < ActiveRecord::Migration
  def change
    create_table :answer_taxons do |t|
      t.integer :answer_id
      t.integer :taxon_id

      t.timestamps
    end
  end
end
