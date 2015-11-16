class DropCelebrities < ActiveRecord::Migration
  def up
    # note that :celebrity_inspirations is actually related to Products

    drop_table :celebrities
    drop_table :celebrities_products
    drop_table :celebrity_images
    drop_table :celebrity_moodboard_items
    drop_table :celebrity_product_accessories
    drop_table :celebrity_style_profiles
  end

  def down
    create_table "celebrities", :force => true do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.string   "slug"
      t.datetime "created_at",                                           :null => false
      t.datetime "updated_at",                                           :null => false
      t.boolean  "is_published"
      t.string   "title"
      t.string   "quote",        :limit => 512
      t.text     "body"
      t.string   "kind",                        :default => "celebrity"
    end

    add_index "celebrities", ["slug"], :name => "index_celebrities_on_slug"

    create_table "celebrities_products", :force => true do |t|
      t.integer "celebrity_id"
      t.integer "product_id"
    end

    add_index "celebrities_products", ["celebrity_id"], :name => "index_celebrities_products_on_celebrity_id"

    create_table "celebrity_images", :force => true do |t|
      t.integer  "celebrity_id"
      t.string   "file_file_name"
      t.string   "file_content_type"
      t.integer  "file_file_size"
      t.datetime "file_updated_at"
      t.boolean  "is_primary",        :default => false
      t.integer  "position"
    end

    add_index "celebrity_images", ["celebrity_id"], :name => "index_celebrity_images_on_celebrity_id"
    add_index "celebrity_images", ["is_primary"], :name => "index_celebrity_images_on_is_primary"

    create_table "celebrity_moodboard_items", :force => true do |t|
      t.integer  "celebrity_id"
      t.boolean  "active",             :default => true
      t.string   "side"
      t.integer  "position",           :default => 0
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.datetime "created_at",                           :null => false
      t.datetime "updated_at",                           :null => false
    end

    add_index "celebrity_moodboard_items", ["celebrity_id"], :name => "index_celebrity_moodboard_items_on_celebrity_id"
    add_index "celebrity_moodboard_items", ["side"], :name => "index_celebrity_moodboard_items_on_side"

    create_table "celebrity_product_accessories", :force => true do |t|
      t.integer  "celebrity_id"
      t.integer  "spree_product_id"
      t.integer  "position"
      t.boolean  "active",             :default => true
      t.string   "title"
      t.string   "source"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.datetime "created_at",                           :null => false
      t.datetime "updated_at",                           :null => false
    end

    add_index "celebrity_product_accessories", ["celebrity_id", "spree_product_id"], :name => "celebrity_product_accessories_main"

    create_table "celebrity_style_profiles", :force => true do |t|
      t.integer  "celebrity_id"
      t.integer  "glam"
      t.integer  "girly"
      t.integer  "classic"
      t.integer  "edgy"
      t.integer  "bohemian"
      t.text     "description"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "celebrity_style_profiles", ["celebrity_id"], :name => "index_celebrity_style_profiles_on_celebrity_id"
  end
end
