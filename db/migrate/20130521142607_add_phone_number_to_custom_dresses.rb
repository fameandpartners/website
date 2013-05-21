class AddPhoneNumberToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :phone_number, :string
  end
end
