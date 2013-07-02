class CreateBlogCelebrities < ActiveRecord::Migration
  def change
    create_table :blog_celebrities do |t|
      t.string :first_name
      t.string :last_name
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end

    add_index :blog_celebrities, :user_id
  end

end
