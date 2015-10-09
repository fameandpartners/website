class AddCategoryToMarketingVisits < ActiveRecord::Migration
  def change
    change_table(:marketing_user_visits) do |t|
      t.column :category, :string
      t.timestamps
    end
  end
end
