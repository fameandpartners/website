class CreateWeddingConsultations < ActiveRecord::Migration
  def change
    create_table :wedding_consultations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact_method
      t.boolean :should_contact
      t.date :wedding_date

      t.timestamps
    end
  end
end
