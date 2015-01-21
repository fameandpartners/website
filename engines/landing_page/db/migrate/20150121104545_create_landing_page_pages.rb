class CreateLandingPagePages < ActiveRecord::Migration
  def change
    create_table :landing_page_pages do |t|

      t.timestamps
    end
  end
end
