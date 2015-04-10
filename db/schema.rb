# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150409125133) do

  create_table "activities", :force => true do |t|
    t.string   "action"
    t.integer  "number"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "actor_type"
    t.integer  "actor_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.text     "info"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "session_key"
  end

  add_index "activities", ["action", "owner_type", "owner_id"], :name => "index_activities_on_action_and_owner_type_and_owner_id"

  create_table "answer_taxons", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "taxon_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "answer_taxons", ["taxon_id", "answer_id"], :name => "index_answer_taxons_on_taxon_id_and_answer_id"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "code"
    t.integer  "glam"
    t.integer  "girly"
    t.integer  "classic"
    t.integer  "edgy"
    t.integer  "bohemian"
    t.integer  "sexiness"
    t.integer  "fashionability"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "blog_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "posts_count"
    t.string   "slug"
  end

  add_index "blog_categories", ["slug"], :name => "index_blog_categories_on_slug"
  add_index "blog_categories", ["user_id"], :name => "index_blog_categories_on_user_id"

  create_table "blog_celebrities", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.datetime "featured_at"
    t.string   "slug"
    t.integer  "celebrity_photo_votes_count"
    t.integer  "primary_photo_id"
  end

  add_index "blog_celebrities", ["featured_at"], :name => "index_blog_celebrities_on_featured_at"
  add_index "blog_celebrities", ["primary_photo_id"], :name => "index_blog_celebrities_on_primary_photo_id"
  add_index "blog_celebrities", ["slug"], :name => "index_blog_celebrities_on_slug"
  add_index "blog_celebrities", ["user_id"], :name => "index_blog_celebrities_on_user_id"

  create_table "blog_celebrity_photo_votes", :force => true do |t|
    t.integer  "vote_type"
    t.integer  "user_id"
    t.integer  "celebrity_photo_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "blog_celebrity_photo_votes", ["celebrity_photo_id"], :name => "index_blog_celebrity_photo_votes_on_celebrity_photo_id"
  add_index "blog_celebrity_photo_votes", ["user_id"], :name => "index_blog_celebrity_photo_votes_on_user_id"

  create_table "blog_celebrity_photos", :force => true do |t|
    t.integer  "celebrity_id"
    t.integer  "post_id"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "likes_count"
    t.integer  "dislikes_count"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "published_at"
  end

  add_index "blog_celebrity_photos", ["celebrity_id"], :name => "index_blog_celebrity_photos_on_celebrity_id"
  add_index "blog_celebrity_photos", ["post_id"], :name => "index_blog_celebrity_photos_on_post_id"
  add_index "blog_celebrity_photos", ["published_at"], :name => "index_blog_celebrity_photos_on_published_at"
  add_index "blog_celebrity_photos", ["user_id"], :name => "index_blog_celebrity_photos_on_user_id"

  create_table "blog_events", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_events", ["slug"], :name => "index_blog_events_on_slug"
  add_index "blog_events", ["user_id"], :name => "index_blog_events_on_user_id"

  create_table "blog_post_photos", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "blog_post_photos", ["post_id"], :name => "index_blog_post_photos_on_post_id"
  add_index "blog_post_photos", ["user_id"], :name => "index_blog_post_photos_on_user_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.datetime "published_at"
    t.datetime "occured_at"
    t.integer  "category_id"
    t.string   "slug"
    t.integer  "post_type_id"
    t.integer  "post_photos_count"
    t.integer  "primary_photo_id"
    t.integer  "event_id"
    t.datetime "featured_at"
    t.string   "description"
    t.string   "video_url",         :limit => 512
    t.string   "primary_type"
  end

  add_index "blog_posts", ["category_id", "published_at"], :name => "index_blog_posts_on_category_id_and_published_at"
  add_index "blog_posts", ["event_id"], :name => "index_blog_posts_on_event_id"
  add_index "blog_posts", ["post_type_id"], :name => "index_blog_posts_on_post_type_id"
  add_index "blog_posts", ["slug"], :name => "index_blog_posts_on_slug"
  add_index "blog_posts", ["user_id"], :name => "index_blog_posts_on_user_id"

  create_table "blog_preferences", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.string   "value_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_preferences", ["key"], :name => "index_blog_preferences_on_key"

  create_table "blog_promo_banners", :force => true do |t|
    t.string   "url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.string   "title"
    t.integer  "position"
    t.boolean  "published"
    t.text     "description"
  end

  add_index "blog_promo_banners", ["published"], :name => "index_blog_promo_banners_on_published"
  add_index "blog_promo_banners", ["user_id"], :name => "index_blog_promo_banners_on_user_id"

  create_table "bridesmaid_party_events", :force => true do |t|
    t.integer  "spree_user_id"
    t.datetime "wedding_date"
    t.integer  "status"
    t.integer  "bridesmaids_count"
    t.boolean  "special_suggestions"
    t.text     "colors"
    t.text     "additional_products"
    t.boolean  "paying_for_bridesmaids", :default => false
  end

  add_index "bridesmaid_party_events", ["spree_user_id"], :name => "index_bridesmaid_party_events_on_spree_user_id"

  create_table "bridesmaid_party_members", :force => true do |t|
    t.integer "event_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.integer "variant_id"
    t.integer "size"
    t.integer "color_id"
    t.integer "spree_user_id"
    t.string  "token"
    t.string  "customization_value_ids"
    t.string  "selected_product_status"
    t.integer "wishlist_item_id"
  end

  add_index "bridesmaid_party_members", ["event_id"], :name => "index_bridesmaid_party_members_on_event_id"
  add_index "bridesmaid_party_members", ["spree_user_id"], :name => "index_bridesmaid_party_members_on_spree_user_id"

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

  create_table "celebrity_inspirations", :force => true do |t|
    t.integer  "spree_product_id"
    t.string   "celebrity_name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.text     "celebrity_description"
  end

  add_index "celebrity_inspirations", ["spree_product_id"], :name => "index_celebrity_inspirations_on_spree_product_id"

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

  create_table "competition_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "inviter_id"
    t.integer  "invitation_id"
    t.boolean  "master",           :default => false
    t.datetime "created_at"
    t.string   "competition_name"
    t.integer  "competition_id"
  end

  create_table "competition_invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "token",            :limit => 50
    t.string   "email"
    t.string   "name"
    t.string   "invitation_type",  :limit => 50
    t.datetime "created_at"
    t.string   "competition_name"
    t.integer  "competition_id"
  end

  create_table "competition_participations", :force => true do |t|
    t.integer  "spree_user_id"
    t.string   "token"
    t.integer  "shares_count",  :default => 0
    t.integer  "views_count",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "custom_dress_images", :force => true do |t|
    t.integer  "custom_dress_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "custom_dresses", :force => true do |t|
    t.text     "description"
    t.string   "color"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "spree_user_id"
    t.string   "phone_number"
    t.string   "size"
    t.boolean  "ghost",         :default => true
    t.date     "required_at"
    t.string   "school_name"
  end

  create_table "customisation_values", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.integer  "product_id"
  end

  add_index "customisation_values", ["product_id"], :name => "index_customisation_values_on_product_id"

  create_table "data_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "data_migrations", ["version"], :name => "unique_data_migrations", :unique => true

  create_table "discounts", :force => true do |t|
    t.integer  "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "discountable_id"
    t.string   "discountable_type"
    t.integer  "sale_id"
  end

  add_index "discounts", ["discountable_id", "discountable_type"], :name => "index_discounts_on_discountable_id_and_discountable_type"
  add_index "discounts", ["sale_id"], :name => "index_discounts_on_sale_id"

  create_table "email_notifications", :force => true do |t|
    t.integer  "spree_user_id"
    t.string   "code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "email_notifications", ["spree_user_id", "code"], :name => "index_email_notifications_on_spree_user_id_and_code"

  create_table "facebook_data", :force => true do |t|
    t.integer  "spree_user_id"
    t.text     "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "facebook_data", ["spree_user_id"], :name => "index_facebook_data_on_spree_user_id"

  create_table "incompatibilities", :force => true do |t|
    t.integer "original_id"
    t.integer "incompatible_id"
  end

  add_index "incompatibilities", ["incompatible_id"], :name => "index_incompatibilities_on_incompatible_id"
  add_index "incompatibilities", ["original_id"], :name => "index_incompatibilities_on_original_id"

  create_table "line_item_personalizations", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "product_id"
    t.integer  "size"
    t.string   "customization_value_ids"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "color"
    t.integer  "color_id"
    t.decimal  "price",                   :precision => 8, :scale => 2, :default => 0.0
    t.integer  "size_id"
  end

  add_index "line_item_personalizations", ["line_item_id"], :name => "index_line_item_personalizations_on_line_item_id"

  create_table "marketing_user_visits", :force => true do |t|
    t.integer "spree_user_id"
    t.string  "user_token",    :limit => 64
    t.integer "visits",                      :default => 0
    t.string  "utm_campaign"
    t.string  "utm_source"
    t.string  "utm_medium"
    t.string  "utm_term"
    t.string  "utm_content"
    t.string  "referrer"
  end

  add_index "marketing_user_visits", ["spree_user_id", "utm_campaign"], :name => "index_marketing_user_visits_on_spree_user_id_and_utm_campaign"
  add_index "marketing_user_visits", ["user_token", "utm_campaign"], :name => "index_marketing_user_visits_on_user_token_and_utm_campaign"

  create_table "moodboard_items", :force => true do |t|
    t.integer  "spree_product_id"
    t.boolean  "active",                            :default => true
    t.string   "item_type",          :limit => 50
    t.string   "content",            :limit => 512
    t.integer  "position",                          :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "name"
    t.string   "title"
  end

  add_index "moodboard_items", ["spree_product_id", "active"], :name => "index_moodboard_items_on_spree_product_id_and_active"

  create_table "option_values_option_values_groups", :id => false, :force => true do |t|
    t.integer "option_value_id"
    t.integer "option_values_group_id"
  end

  add_index "option_values_option_values_groups", ["option_value_id"], :name => "opovg_option_value_id"
  add_index "option_values_option_values_groups", ["option_values_group_id"], :name => "opovg_option_group_id"

  create_table "payment_requests", :force => true do |t|
    t.integer  "order_id"
    t.string   "recipient_full_name"
    t.string   "recipient_email"
    t.text     "message"
    t.string   "token"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "payment_requests", ["order_id"], :name => "index_payment_requests_on_order_id"
  add_index "payment_requests", ["token"], :name => "index_payment_requests_on_token"

  create_table "product_accessories", :force => true do |t|
    t.integer  "style_id"
    t.integer  "spree_product_id"
    t.integer  "position"
    t.boolean  "active",                                                          :default => true
    t.string   "title",              :limit => 512
    t.string   "name",               :limit => 512
    t.string   "source",             :limit => 512
    t.decimal  "price",                             :precision => 8, :scale => 2
    t.string   "currency"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
  end

  add_index "product_accessories", ["spree_product_id"], :name => "index_product_accessories_on_spree_product_id"
  add_index "product_accessories", ["style_id"], :name => "index_product_accessories_on_style_id"

  create_table "product_color_values", :force => true do |t|
    t.integer "product_id"
    t.integer "option_value_id"
  end

  add_index "product_color_values", ["product_id"], :name => "index_product_color_values_on_product_id"

  create_table "product_personalizations", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "line_item_id"
    t.integer  "user_id"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_email"
    t.boolean  "change_color"
    t.boolean  "change_hem_length"
    t.boolean  "change_neck_line"
    t.boolean  "change_fabric_type"
    t.boolean  "merge_styles"
    t.boolean  "add_beads_or_sequins"
    t.text     "comments"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "product_reservations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "school_name"
    t.string   "formal_name"
    t.string   "school_year"
    t.string   "color"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "product_reservations", ["user_id"], :name => "index_product_reservations_on_user_id"

  create_table "product_style_profiles", :force => true do |t|
    t.integer  "product_id"
    t.integer  "glam"
    t.integer  "girly"
    t.integer  "classic"
    t.integer  "edgy"
    t.integer  "bohemian"
    t.integer  "apple"
    t.integer  "pear"
    t.integer  "strawberry"
    t.integer  "hour_glass"
    t.integer  "column"
    t.integer  "bra_aaa"
    t.integer  "bra_aa"
    t.integer  "bra_a"
    t.integer  "bra_b"
    t.integer  "bra_c"
    t.integer  "bra_d"
    t.integer  "bra_e"
    t.integer  "bra_fpp"
    t.integer  "sexiness"
    t.integer  "fashionability"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "athletic"
    t.integer  "petite"
  end

  add_index "product_style_profiles", ["product_id"], :name => "index_product_style_profiles_on_product_id"

  create_table "product_videos", :force => true do |t|
    t.integer  "spree_product_id"
    t.integer  "spree_option_value_id"
    t.boolean  "is_master",                            :default => false
    t.string   "color"
    t.string   "url",                   :limit => 512
    t.string   "video_id"
    t.integer  "position"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "product_videos", ["spree_product_id"], :name => "index_product_videos_on_spree_product_id"

  create_table "questions", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "text"
    t.string   "position"
    t.string   "partial"
    t.boolean  "multiple",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "populate"
    t.integer  "step"
  end

  add_index "questions", ["position"], :name => "index_questions_on_position"
  add_index "questions", ["quiz_id"], :name => "index_questions_on_quiz_id"

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "similarities", :force => true do |t|
    t.integer "original_id"
    t.integer "similar_id"
    t.float   "coefficient"
  end

  add_index "similarities", ["original_id"], :name => "index_similarities_on_original_id"
  add_index "similarities", ["similar_id"], :name => "index_similarities_on_similar_id"

  create_table "site_versions", :force => true do |t|
    t.integer  "zone_id"
    t.string   "name"
    t.string   "permalink"
    t.boolean  "default",                 :default => false
    t.boolean  "active",                  :default => false
    t.string   "currency"
    t.string   "locale"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.date     "exchange_rate_timestamp"
    t.decimal  "exchange_rate",           :default => 1.0
  end

  add_index "site_versions", ["zone_id"], :name => "index_site_versions_on_zone_id"

  create_table "spree_activators", :force => true do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "event_name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy", :default => "all"
    t.string   "code"
    t.boolean  "advertise",    :default => false
    t.string   "path"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "spree_addresses", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "email"
  end

  add_index "spree_addresses", ["firstname"], :name => "index_addresses_on_firstname"
  add_index "spree_addresses", ["lastname"], :name => "index_addresses_on_lastname"

  create_table "spree_adjustments", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.integer  "originator_id"
    t.string   "originator_type"
    t.decimal  "amount",          :precision => 10, :scale => 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "locked"
    t.boolean  "eligible",                                       :default => true
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "spree_adjustments", ["adjustable_id"], :name => "index_adjustments_on_order_id"

  create_table "spree_assets", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    :limit => 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
  end

  add_index "spree_assets", ["viewable_id"], :name => "index_assets_on_viewable_id"
  add_index "spree_assets", ["viewable_type", "type"], :name => "index_assets_on_viewable_type_and_type"

  create_table "spree_authentication_methods", :force => true do |t|
    t.string   "environment"
    t.string   "provider"
    t.string   "api_key"
    t.string   "api_secret"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "spree_banner_boxes", :force => true do |t|
    t.string   "presentation"
    t.string   "url"
    t.string   "category"
    t.integer  "position"
    t.boolean  "enabled",                 :default => false
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_size"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "is_small"
    t.text     "css_class"
    t.text     "title"
  end

  create_table "spree_calculators", :force => true do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "spree_configurations", :force => true do |t|
    t.string   "name"
    t.string   "type",       :limit => 50
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "spree_configurations", ["name", "type"], :name => "index_spree_configurations_on_name_and_type"

  create_table "spree_countries", :force => true do |t|
    t.string  "iso_name"
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.integer "numcode"
    t.boolean "states_required", :default => true
  end

  create_table "spree_credit_cards", :force => true do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "start_month"
    t.string   "start_year"
    t.string   "issue_number"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "spree_gateways", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.string   "server",      :default => "test"
    t.boolean  "test_mode",   :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spree_inventory_units", :force => true do |t|
    t.integer  "lock_version",            :default => 0
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.integer  "return_authorization_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "spree_inventory_units", ["order_id"], :name => "index_inventory_units_on_order_id"
  add_index "spree_inventory_units", ["shipment_id"], :name => "index_inventory_units_on_shipment_id"
  add_index "spree_inventory_units", ["variant_id"], :name => "index_inventory_units_on_variant_id"

  create_table "spree_line_items", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                 :null => false
    t.decimal  "price",      :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "currency"
    t.decimal  "old_price",  :precision => 8, :scale => 2
  end

  add_index "spree_line_items", ["order_id"], :name => "index_spree_line_items_on_order_id"
  add_index "spree_line_items", ["variant_id"], :name => "index_spree_line_items_on_variant_id"

  create_table "spree_log_entries", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "spree_mail_methods", :force => true do |t|
    t.string   "environment"
    t.boolean  "active",      :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_option_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "presentation", :limit => 100
    t.integer  "position",                    :default => 0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "spree_option_types_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "value"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.boolean  "use_in_customisation", :default => false
  end

  add_index "spree_option_values", ["option_type_id"], :name => "index_spree_option_values_on_option_type_id"

  create_table "spree_option_values_groups", :force => true do |t|
    t.integer  "option_type_id"
    t.string   "name"
    t.string   "presentation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "spree_option_values_groups", ["option_type_id"], :name => "index_spree_option_values_groups_on_option_type_id"

  create_table "spree_option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], :name => "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], :name => "index_spree_option_values_variants_on_variant_id"

  create_table "spree_orders", :force => true do |t|
    t.string   "number",               :limit => 15
    t.decimal  "item_total",                         :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                              :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "state"
    t.decimal  "adjustment_total",                   :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                      :precision => 10, :scale => 2, :default => 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.string   "currency"
    t.string   "last_ip_address"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.date     "required_to"
  end

  add_index "spree_orders", ["created_at"], :name => "index_spree_orders_on_created_at"
  add_index "spree_orders", ["number"], :name => "index_spree_orders_on_number"
  add_index "spree_orders", ["shipment_state"], :name => "index_spree_orders_on_shipment_state"
  add_index "spree_orders", ["user_id"], :name => "index_spree_orders_on_user_id"

  create_table "spree_payment_methods", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "display_on"
  end

  create_table "spree_payments", :force => true do |t|
    t.decimal  "amount",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.string   "identifier"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["order_id"], :name => "index_spree_payments_on_order_id"

  create_table "spree_paypal_accounts", :force => true do |t|
    t.string "email"
    t.string "payer_id"
    t.string "payer_country"
    t.string "payer_status"
  end

  create_table "spree_paypal_express_checkouts", :force => true do |t|
    t.string   "token"
    t.string   "payer_id"
    t.string   "transaction_id"
    t.string   "state",                 :default => "complete"
    t.string   "refund_transaction_id"
    t.datetime "refunded_at"
    t.string   "refund_type"
    t.datetime "created_at"
  end

  add_index "spree_paypal_express_checkouts", ["transaction_id"], :name => "index_spree_paypal_express_checkouts_on_transaction_id"

  create_table "spree_preferences", :force => true do |t|
    t.text     "value"
    t.string   "key"
    t.string   "value_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "spree_preferences", ["key"], :name => "index_spree_preferences_on_key", :unique => true

  create_table "spree_prices", :force => true do |t|
    t.integer "variant_id",                               :null => false
    t.decimal "amount",     :precision => 8, :scale => 2
    t.string  "currency"
  end

  add_index "spree_prices", ["variant_id"], :name => "index_spree_prices_on_variant_id"

  create_table "spree_product_option_types", :force => true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "spree_product_option_types", ["option_type_id"], :name => "index_spree_product_option_types_on_option_type_id"
  add_index "spree_product_option_types", ["product_id"], :name => "index_spree_product_option_types_on_product_id"

  create_table "spree_product_properties", :force => true do |t|
    t.string   "value",       :limit => 512
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "position",                   :default => 0
  end

  add_index "spree_product_properties", ["product_id"], :name => "index_product_properties_on_product_id"

  create_table "spree_products", :force => true do |t|
    t.string   "name",                 :default => "",    :null => false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "permalink"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.integer  "count_on_hand",        :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "on_demand",            :default => false
    t.boolean  "featured",             :default => false
    t.integer  "position",             :default => 0
    t.boolean  "hidden",               :default => false
    t.boolean  "is_service",           :default => false
  end

  add_index "spree_products", ["available_on"], :name => "index_spree_products_on_available_on"
  add_index "spree_products", ["deleted_at"], :name => "index_spree_products_on_deleted_at"
  add_index "spree_products", ["name"], :name => "index_spree_products_on_name"
  add_index "spree_products", ["permalink"], :name => "index_spree_products_on_permalink"
  add_index "spree_products", ["permalink"], :name => "permalink_idx_unique", :unique => true

  create_table "spree_products_promotion_rules", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], :name => "index_products_promotion_rules_on_product_id"
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], :name => "index_products_promotion_rules_on_promotion_rule_id"

  create_table "spree_products_taxons", :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "spree_products_taxons", ["product_id"], :name => "index_spree_products_taxons_on_product_id"
  add_index "spree_products_taxons", ["taxon_id"], :name => "index_spree_products_taxons_on_taxon_id"

  create_table "spree_promotion_action_line_items", :force => true do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            :default => 1
  end

  create_table "spree_promotion_actions", :force => true do |t|
    t.integer "activator_id"
    t.integer "position"
    t.string  "type"
  end

  create_table "spree_promotion_rules", :force => true do |t|
    t.integer  "activator_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_promotion_rules", ["product_group_id"], :name => "index_promotion_rules_on_product_group_id"
  add_index "spree_promotion_rules", ["user_id"], :name => "index_promotion_rules_on_user_id"

  create_table "spree_promotion_rules_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], :name => "index_promotion_rules_users_on_promotion_rule_id"
  add_index "spree_promotion_rules_users", ["user_id"], :name => "index_promotion_rules_users_on_user_id"

  create_table "spree_properties", :force => true do |t|
    t.string   "name"
    t.string   "presentation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spree_properties_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_return_authorizations", :force => true do |t|
    t.string   "number"
    t.string   "state"
    t.decimal  "amount",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.text     "reason"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "spree_roles", :force => true do |t|
    t.string "name"
  end

  create_table "spree_roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], :name => "index_spree_roles_users_on_role_id"
  add_index "spree_roles_users", ["user_id"], :name => "index_spree_roles_users_on_user_id"

  create_table "spree_sales", :force => true do |t|
    t.boolean  "is_active"
    t.decimal  "discount_size"
    t.integer  "discount_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name"
    t.boolean  "sitewide",      :default => false
  end

  create_table "spree_shipments", :force => true do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",               :precision => 8, :scale => 2
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "shipping_method_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "spree_shipments", ["number"], :name => "index_shipments_on_number"
  add_index "spree_shipments", ["order_id"], :name => "index_spree_shipments_on_order_id"

  create_table "spree_shipping_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_shipping_methods", :force => true do |t|
    t.string   "name"
    t.integer  "zone_id"
    t.string   "display_on"
    t.integer  "shipping_category_id"
    t.boolean  "match_none"
    t.boolean  "match_all"
    t.boolean  "match_one"
    t.datetime "deleted_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "spree_skrill_transactions", :force => true do |t|
    t.string   "email"
    t.float    "amount"
    t.string   "currency"
    t.integer  "transaction_id"
    t.integer  "customer_id"
    t.string   "payment_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_state_changes", :force => true do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "country_id"
  end

  create_table "spree_tax_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "spree_tax_rates", :force => true do |t|
    t.decimal  "amount",             :precision => 8, :scale => 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                                :default => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "name"
    t.boolean  "show_rate_in_label",                               :default => true
  end

  create_table "spree_taxon_banners", :force => true do |t|
    t.integer  "spree_taxon_id"
    t.string   "title"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "footer_text"
    t.text     "seo_description"
  end

  add_index "spree_taxon_banners", ["spree_taxon_id"], :name => "index_spree_taxon_banners_on_spree_taxon_id"

  create_table "spree_taxonomies", :force => true do |t|
    t.string   "name",                      :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "position",   :default => 0
  end

  create_table "spree_taxons", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position",          :default => 0
    t.string   "name",                             :null => false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "title"
  end

  add_index "spree_taxons", ["parent_id"], :name => "index_taxons_on_parent_id"
  add_index "spree_taxons", ["permalink"], :name => "index_taxons_on_permalink"
  add_index "spree_taxons", ["taxonomy_id"], :name => "index_taxons_on_taxonomy_id"

  create_table "spree_tokenized_permissions", :force => true do |t|
    t.integer  "permissable_id"
    t.string   "permissable_type"
    t.string   "token"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_tokenized_permissions", ["permissable_id", "permissable_type"], :name => "index_tokenized_name_and_type"

  create_table "spree_trackers", :force => true do |t|
    t.string   "environment"
    t.string   "analytics_id"
    t.boolean  "active",       :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "spree_user_authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_users", :force => true do |t|
    t.string   "encrypted_password",                       :limit => 128
    t.string   "password_salt",                            :limit => 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                                           :default => 0, :null => false
    t.integer  "failed_attempts",                                         :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "spree_api_key",                            :limit => 48
    t.datetime "remember_created_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "sign_up_via"
    t.text     "description"
    t.string   "slug"
    t.string   "sign_up_reason"
    t.string   "phone"
    t.boolean  "newsletter"
    t.datetime "last_cart_notification_sent_at"
    t.datetime "last_wishlist_notification_sent_at"
    t.datetime "last_quiz_notification_sent_at"
    t.integer  "site_version_id"
    t.date     "dob"
    t.datetime "last_payment_failed_notification_sent_at"
    t.date     "birthday"
  end

  add_index "spree_users", ["email"], :name => "email_idx_unique", :unique => true
  add_index "spree_users", ["slug"], :name => "index_spree_users_on_slug"

  create_table "spree_variants", :force => true do |t|
    t.string   "sku",                                         :default => "",    :null => false
    t.decimal  "weight",        :precision => 8, :scale => 2
    t.decimal  "height",        :precision => 8, :scale => 2
    t.decimal  "width",         :precision => 8, :scale => 2
    t.decimal  "depth",         :precision => 8, :scale => 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                   :default => false
    t.integer  "product_id"
    t.integer  "count_on_hand",                               :default => 0
    t.decimal  "cost_price",    :precision => 8, :scale => 2
    t.integer  "position"
    t.integer  "lock_version",                                :default => 0
    t.boolean  "on_demand",                                   :default => false
    t.string   "cost_currency"
  end

  add_index "spree_variants", ["product_id"], :name => "index_spree_variants_on_product_id"

  create_table "spree_zone_members", :force => true do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "spree_zone_prices", :force => true do |t|
    t.integer "variant_id"
    t.integer "zone_id"
    t.decimal "amount",     :precision => 8, :scale => 2
    t.string  "currency"
  end

  add_index "spree_zone_prices", ["variant_id"], :name => "index_spree_zone_prices_on_variant_id"
  add_index "spree_zone_prices", ["zone_id"], :name => "index_spree_zone_prices_on_zone_id"

  create_table "spree_zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        :default => false
    t.integer  "zone_members_count", :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "styles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_style_profile_taxons", :force => true do |t|
    t.integer "user_style_profile_id"
    t.integer "taxon_id"
    t.integer "capacity"
  end

  create_table "user_style_profiles", :force => true do |t|
    t.integer  "user_id"
    t.float    "glam"
    t.float    "girly"
    t.float    "classic"
    t.float    "edgy"
    t.float    "bohemian"
    t.float    "sexiness"
    t.float    "fashionability"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "nail_colours"
    t.string   "brands"
    t.string   "trends"
    t.string   "hair_colour"
    t.string   "skin_colour"
    t.string   "body_shape"
    t.string   "typical_size"
    t.string   "bra_size"
    t.string   "colours"
    t.text     "serialized_answers"
  end

  add_index "user_style_profiles", ["user_id"], :name => "index_style_reports_on_spree_user_id"

  create_table "wishlist_items", :force => true do |t|
    t.integer  "spree_user_id"
    t.integer  "spree_variant_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "quantity",         :default => 1
    t.integer  "spree_product_id"
    t.integer  "product_color_id"
  end

  add_index "wishlist_items", ["spree_product_id"], :name => "index_wishlist_items_on_spree_product_id"
  add_index "wishlist_items", ["spree_user_id"], :name => "index_wishlist_items_on_spree_user_id"

end
