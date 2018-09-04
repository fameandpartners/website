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

ActiveRecord::Schema.define(:version => 20180904045723) do

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
  add_index "activities", ["action"], :name => "index_activities_on_action"
  add_index "activities", ["owner_type"], :name => "index_activities_on_owner_type"

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

  create_table "batch_collection_line_items", :force => true do |t|
    t.integer  "batch_collection_id"
    t.integer  "line_item_id"
    t.datetime "projected_delivery_date"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.datetime "deleted_at"
  end

  add_index "batch_collection_line_items", ["deleted_at"], :name => "index_batch_collection_line_items_on_deleted_at"

  create_table "batch_collections", :force => true do |t|
    t.string   "batch_key"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "batch_collections", ["batch_key"], :name => "index_batch_collections_on_batch_key"

  create_table "bergen_return_item_processes", :force => true do |t|
    t.string   "aasm_state"
    t.integer  "return_request_item_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "failed",                 :default => false
    t.string   "sentry_id"
  end

  create_table "bulk_order_updates", :force => true do |t|
    t.text     "user"
    t.text     "filename"
    t.datetime "processed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "categories", :force => true do |t|
    t.string "category"
    t.string "subcategory"
  end

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

  create_table "contentful_routes", :force => true do |t|
    t.string   "route_name"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contentful_versions", :force => true do |t|
    t.string   "change_message"
    t.text     "payload"
    t.integer  "user_id"
    t.boolean  "is_live",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
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
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.integer  "product_id"
    t.string   "customisation_type",                               :default => "cut"
    t.string   "point_of_view",                                    :default => "front"
  end

  add_index "customisation_values", ["product_id"], :name => "index_customisation_values_on_product_id"

  create_table "customization_visualizations", :force => true do |t|
    t.string   "customization_ids", :limit => 1024
    t.string   "incompatible_ids",  :limit => 1024
    t.jsonb    "render_urls"
    t.integer  "product_id"
    t.string   "length"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "silhouette"
    t.string   "neckline"
  end

  add_index "customization_visualizations", ["length", "silhouette", "neckline"], :name => "dress_features"
  add_index "customization_visualizations", ["product_id"], :name => "index_customization_visualizations_on_product_id"

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
  add_index "discounts", ["discountable_type", "discountable_id", "sale_id"], :name => "index_discounts_on_discountable_and_sale_id", :unique => true
  add_index "discounts", ["sale_id"], :name => "index_discounts_on_sale_id"

  create_table "email_notifications", :force => true do |t|
    t.integer  "spree_user_id"
    t.string   "code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "email_notifications", ["spree_user_id", "code"], :name => "index_email_notifications_on_spree_user_id_and_code"

  create_table "fabric_card_colours", :force => true do |t|
    t.text     "position"
    t.text     "code"
    t.integer  "fabric_colour_id"
    t.integer  "fabric_card_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "fabric_card_colours", ["fabric_card_id"], :name => "index_fabric_card_colours_on_fabric_card_id"
  add_index "fabric_card_colours", ["fabric_colour_id"], :name => "index_fabric_card_colours_on_fabric_colour_id"

  create_table "fabric_cards", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "code"
    t.text     "name_zh"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "fabric_colours", :force => true do |t|
    t.text     "name"
    t.integer  "dress_colour_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "fabrication_events", :force => true do |t|
    t.string   "fabrication_uuid"
    t.string   "event_type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "occurred_at"
  end

  add_index "fabrication_events", ["fabrication_uuid"], :name => "index_fabrication_events_on_fabrication_uuid"

  create_table "fabrications", :force => true do |t|
    t.integer  "line_item_id"
    t.string   "purchase_order_number"
    t.string   "state"
    t.string   "factory_name"
    t.date     "sla_date"
    t.string   "uuid"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "fabrications", ["line_item_id"], :name => "index_fabrications_on_line_item_id", :unique => true
  add_index "fabrications", ["purchase_order_number"], :name => "index_fabrications_on_purchase_order_number"
  add_index "fabrications", ["uuid"], :name => "index_fabrications_on_uuid", :unique => true

  create_table "fabrics", :force => true do |t|
    t.string   "name"
    t.string   "presentation"
    t.string   "price_aud"
    t.string   "price_usd"
    t.string   "material"
    t.string   "image_url"
    t.integer  "option_value_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "option_fabric_color_value_id"
  end

  add_index "fabrics", ["option_value_id"], :name => "index_fabrics_on_option_value_id"
  add_index "fabrics", ["option_value_id"], :name => "ix_fabrics_on_fabric_color_id"

  create_table "fabrics_products", :force => true do |t|
    t.integer "fabric_id"
    t.integer "product_id"
    t.boolean "recommended"
    t.string  "description"
    t.boolean "active",      :default => true
  end

  create_table "facebook_accounts", :force => true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.integer  "account_status"
    t.integer  "amount_spent"
    t.string   "currency"
    t.float    "age"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "facebook_ad_creatives", :force => true do |t|
    t.string   "facebook_id"
    t.integer  "facebook_ad_id"
    t.string   "image_url"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "facebook_ad_insights", :force => true do |t|
    t.integer  "facebook_ad_id"
    t.integer  "clicks"
    t.integer  "cost_per_action_type"
    t.float    "cpc"
    t.float    "cpm"
    t.float    "cpp"
    t.float    "ctr"
    t.datetime "date_start"
    t.datetime "date_stop"
    t.float    "frequency"
    t.float    "reach"
    t.json     "relevance_score"
    t.json     "social_impressions"
    t.float    "spend"
    t.float    "total_actions"
    t.float    "total_unique_actions"
    t.json     "website_ctr"
    t.integer  "website_clicks"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.json     "actions"
    t.json     "action_values"
  end

  create_table "facebook_ads", :force => true do |t|
    t.string   "facebook_id"
    t.string   "facebook_adset_id"
    t.string   "name"
    t.datetime "created_time"
    t.datetime "updated_time"
    t.float    "bid_amount"
    t.string   "status"
    t.json     "recommendations"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "facebook_adsets", :force => true do |t|
    t.string   "facebook_campaign_id"
    t.string   "facebook_id"
    t.string   "name"
    t.json     "adlabels"
    t.json     "adset_schedule"
    t.float    "bid_amount"
    t.float    "daily_budget"
    t.datetime "created_time"
    t.datetime "updated_time"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "optimization_goal"
    t.string   "status"
    t.json     "targeting"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "facebook_campaigns", :force => true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.datetime "created_time"
    t.datetime "start_time"
    t.datetime "stop_time"
    t.datetime "updated_time"
    t.string   "status"
    t.json     "recommendations"
    t.string   "facebook_account_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "facebook_data", :force => true do |t|
    t.integer  "spree_user_id"
    t.text     "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "facebook_data", ["spree_user_id"], :name => "index_facebook_data_on_spree_user_id", :unique => true

  create_table "factories", :force => true do |t|
    t.text     "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "production_email"
  end

  create_table "global_skus", :force => true do |t|
    t.string   "sku"
    t.string   "style_number"
    t.string   "product_name"
    t.string   "size"
    t.string   "color_id"
    t.string   "color_name"
    t.string   "customisation_id"
    t.string   "customisation_name"
    t.string   "height_value"
    t.text     "data"
    t.integer  "product_id"
    t.integer  "variant_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "fabric_id"
    t.string   "fabric_name"
  end

  add_index "global_skus", ["product_id"], :name => "index_global_skus_on_product_id"
  add_index "global_skus", ["sku"], :name => "index_global_skus_on_sku", :unique => true
  add_index "global_skus", ["variant_id"], :name => "index_global_skus_on_variant_id"

  create_table "incompatibilities", :force => true do |t|
    t.integer "original_id"
    t.integer "incompatible_id"
  end

  add_index "incompatibilities", ["incompatible_id"], :name => "index_incompatibilities_on_incompatible_id"
  add_index "incompatibilities", ["original_id"], :name => "index_incompatibilities_on_original_id"

  create_table "inspirations", :force => true do |t|
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

  add_index "inspirations", ["spree_product_id", "active"], :name => "index_inspirations_on_spree_product_id_and_active"

  create_table "item_return_events", :force => true do |t|
    t.string   "item_return_uuid"
    t.string   "event_type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "occurred_at"
  end

  add_index "item_return_events", ["item_return_uuid"], :name => "index_item_return_events_on_item_return_uuid"

  create_table "item_return_labels", :force => true do |t|
    t.string   "label_url"
    t.string   "carrier"
    t.string   "label_image_url"
    t.string   "label_pdf_url"
    t.integer  "item_return_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "barcode"
  end

  create_table "item_returns", :force => true do |t|
    t.string   "order_number"
    t.integer  "line_item_id"
    t.integer  "qty"
    t.string   "requested_action"
    t.datetime "requested_at"
    t.integer  "request_id"
    t.string   "reason_category"
    t.string   "reason_sub_category"
    t.text     "request_notes"
    t.string   "customer_name"
    t.string   "contact_email"
    t.string   "acceptance_status"
    t.text     "comments"
    t.string   "product_name"
    t.string   "product_style_number"
    t.string   "product_colour"
    t.string   "product_size"
    t.boolean  "product_customisations"
    t.date     "received_on"
    t.string   "received_location"
    t.string   "order_payment_method"
    t.date     "order_payment_date"
    t.integer  "order_paid_amount"
    t.string   "order_paid_currency"
    t.string   "order_payment_ref"
    t.string   "refund_status"
    t.string   "refund_ref"
    t.string   "refund_method"
    t.integer  "refund_amount"
    t.datetime "refunded_at"
    t.string   "uuid"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.boolean  "factory_fault"
    t.integer  "item_price"
    t.integer  "item_price_adjusted"
    t.string   "factory_fault_reason"
    t.string   "bergen_asn_number"
    t.integer  "bergen_actual_quantity"
    t.integer  "bergen_damaged_quantity"
    t.string   "shippo_tracking_number"
    t.string   "shippo_label_url"
    t.integer  "item_return_label_id"
  end

  add_index "item_returns", ["item_return_label_id"], :name => "index_item_returns_on_item_return_label_id"
  add_index "item_returns", ["line_item_id"], :name => "index_item_returns_on_line_item_id", :unique => true
  add_index "item_returns", ["order_number"], :name => "index_item_returns_on_order_number"
  add_index "item_returns", ["uuid"], :name => "index_item_returns_on_uuid", :unique => true

  create_table "layer_cads", :force => true do |t|
    t.integer  "product_id"
    t.integer  "position"
    t.string   "base_image_name"
    t.string   "layer_image_name"
    t.string   "base_image_file_name"
    t.string   "base_image_content_type"
    t.integer  "base_image_file_size"
    t.datetime "base_image_updated_at"
    t.string   "layer_image_file_name"
    t.string   "layer_image_content_type"
    t.integer  "layer_image_file_size"
    t.datetime "layer_image_updated_at"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "customizations_enabled_for", :default => "--- []\n"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "line_item_making_options", :force => true do |t|
    t.integer  "product_id"
    t.integer  "variant_id"
    t.integer  "line_item_id"
    t.integer  "making_option_id"
    t.decimal  "price",                          :precision => 10, :scale => 2
    t.string   "currency",         :limit => 10
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "line_item_making_options", ["line_item_id"], :name => "index_line_item_making_options_on_line_item"

  create_table "line_item_personalizations", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "product_id"
    t.string   "size"
    t.string   "customization_value_ids"
    t.datetime "created_at",                                                                                   :null => false
    t.datetime "updated_at",                                                                                   :null => false
    t.string   "color"
    t.integer  "color_id"
    t.decimal  "price",                                  :precision => 8, :scale => 2, :default => 0.0
    t.integer  "size_id"
    t.string   "height",                                                               :default => "standard"
    t.string   "height_value"
    t.string   "height_unit"
    t.string   "sku",                     :limit => 128
  end

  add_index "line_item_personalizations", ["line_item_id"], :name => "index_line_item_personalizations_on_line_item_id"

  create_table "line_item_size_normalisations", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "line_item_personalization_id"
    t.string   "order_number"
    t.datetime "order_created_at"
    t.string   "currency"
    t.string   "site_version"
    t.string   "old_size_value"
    t.integer  "old_size_id"
    t.integer  "old_variant_id"
    t.string   "new_size_value"
    t.integer  "new_size_id"
    t.integer  "new_variant_id"
    t.string   "messages"
    t.string   "state"
    t.datetime "processed_at"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "line_item_size_normalisations", ["line_item_id"], :name => "index_line_item_size_normalisations_on_line_item_id"
  add_index "line_item_size_normalisations", ["new_size_id"], :name => "index_line_item_size_normalisations_on_new_size_id"
  add_index "line_item_size_normalisations", ["new_variant_id"], :name => "index_line_item_size_normalisations_on_new_variant_id"
  add_index "line_item_size_normalisations", ["old_size_id"], :name => "index_line_item_size_normalisations_on_old_size_id"
  add_index "line_item_size_normalisations", ["old_variant_id"], :name => "index_line_item_size_normalisations_on_old_variant_id"

  create_table "line_item_updates", :force => true do |t|
    t.integer  "row_number"
    t.text     "order_date"
    t.text     "order_number"
    t.text     "style_name"
    t.text     "size"
    t.text     "quantity"
    t.text     "colour"
    t.text     "tracking_number"
    t.text     "dispatch_date"
    t.text     "delivery_method"
    t.integer  "bulk_order_update_id"
    t.integer  "order_id"
    t.integer  "line_item_id"
    t.integer  "shipment_id"
    t.text     "state"
    t.text     "process_reason"
    t.text     "match_errors"
    t.text     "shipment_errors"
    t.datetime "processed_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "make_state"
    t.string   "raw_line_item"
    t.text     "setup_ship_errors"
  end

  add_index "line_item_updates", ["bulk_order_update_id"], :name => "index_line_item_updates_on_bulk_order_update_id"

  create_table "manually_managed_returns", :force => true do |t|
    t.integer  "item_return_id"
    t.integer  "item_return_event_id"
    t.integer  "line_item_id"
    t.string   "import_status"
    t.string   "row_number"
    t.string   "rj_ident"
    t.string   "column_b"
    t.string   "receive_state"
    t.string   "spree_order_number"
    t.string   "return_cancellation_credit"
    t.string   "name"
    t.string   "order_date"
    t.string   "order_month"
    t.string   "return_requested_on"
    t.text     "comments"
    t.string   "product"
    t.string   "size"
    t.string   "colour"
    t.string   "return_category"
    t.string   "return_sub_category"
    t.string   "return_office"
    t.string   "received"
    t.string   "in_inventory"
    t.text     "notes"
    t.string   "restocking"
    t.string   "returned_to_factory"
    t.string   "refund_status"
    t.string   "payment_method"
    t.string   "refund_method"
    t.string   "currency"
    t.string   "amount_paid"
    t.string   "spree_amount_paid"
    t.string   "refund_amount"
    t.string   "date_refunded"
    t.string   "email"
    t.string   "account_name"
    t.string   "account_number"
    t.string   "account_bsb"
    t.string   "account_swift"
    t.text     "customers_notes"
    t.string   "quantity"
    t.string   "deleted_row"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "marketing_body_calculator_measures", :force => true do |t|
    t.string   "email"
    t.string   "shape"
    t.string   "size"
    t.float    "bust_circumference",       :default => 0.0
    t.float    "under_bust_circumference", :default => 0.0
    t.float    "waist_circumference",      :default => 0.0
    t.float    "hip_circumference",        :default => 0.0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "unit"
  end

  create_table "marketing_order_traffic_parameters", :force => true do |t|
    t.integer  "order_id"
    t.string   "utm_campaign"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "marketing_order_traffic_parameters", ["order_id"], :name => "index_marketing_order_traffic_parameters_on_order_id"

  create_table "marketing_user_visits", :force => true do |t|
    t.integer  "spree_user_id"
    t.string   "user_token",    :limit => 64
    t.integer  "visits",                      :default => 0
    t.string   "utm_campaign"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "referrer"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marketing_user_visits", ["spree_user_id", "utm_campaign"], :name => "index_marketing_user_visits_on_spree_user_id_and_utm_campaign"
  add_index "marketing_user_visits", ["user_token", "utm_campaign"], :name => "index_marketing_user_visits_on_user_token_and_utm_campaign"

  create_table "moodboard_collaborators", :force => true do |t|
    t.integer  "moodboard_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "name"
    t.datetime "accepted_at"
    t.datetime "deleted_at"
    t.string   "deleted_by"
    t.boolean  "mute_notifications"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "moodboard_collaborators", ["email"], :name => "index_moodboard_collaborators_on_email"
  add_index "moodboard_collaborators", ["moodboard_id"], :name => "index_moodboard_collaborators_on_moodboard_id"
  add_index "moodboard_collaborators", ["user_id"], :name => "index_moodboard_collaborators_on_user_id"

  create_table "moodboard_item_comments", :force => true do |t|
    t.integer  "moodboard_item_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "moodboard_item_comments", ["moodboard_item_id"], :name => "index_moodboard_comments_on_moodboard_item_id"

  create_table "moodboard_item_events", :force => true do |t|
    t.string   "moodboard_item_uuid"
    t.string   "event_type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "occurred_at"
  end

  add_index "moodboard_item_events", ["moodboard_item_uuid"], :name => "index_moodboard_item_events_on_moodboard_item_uuid"

  create_table "moodboard_items", :force => true do |t|
    t.string   "uuid"
    t.integer  "moodboard_id"
    t.integer  "product_id",                             :null => false
    t.integer  "product_color_value_id"
    t.integer  "color_id",                               :null => false
    t.integer  "variant_id"
    t.integer  "user_id",                                :null => false
    t.integer  "likes",                  :default => 0
    t.text     "comments"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "user_likes",             :default => ""
  end

  add_index "moodboard_items", ["color_id"], :name => "index_moodboard_items_on_color_id"
  add_index "moodboard_items", ["moodboard_id"], :name => "index_moodboard_items_on_moodboard_id"
  add_index "moodboard_items", ["product_color_value_id"], :name => "index_moodboard_items_on_product_color_value_id"
  add_index "moodboard_items", ["product_id"], :name => "index_moodboard_items_on_product_id"
  add_index "moodboard_items", ["user_id"], :name => "index_moodboard_items_on_user_id"
  add_index "moodboard_items", ["uuid"], :name => "index_moodboard_items_on_uuid"
  add_index "moodboard_items", ["variant_id"], :name => "index_moodboard_items_on_variant_id"

  create_table "moodboards", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "purpose",            :default => "default", :null => false
    t.date     "event_date"
    t.text     "description"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "event_progress"
    t.string   "owner_relationship"
    t.string   "guest_count"
    t.string   "bride_first_name"
    t.string   "bride_last_name"
  end

  add_index "moodboards", ["user_id"], :name => "index_moodboards_on_user_id"

  create_table "newgistics_schedulers", :force => true do |t|
    t.string   "last_successful_run"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "name"
  end

  create_table "next_logistics_return_request_processes", :force => true do |t|
    t.integer  "order_return_request_id"
    t.string   "aasm_state"
    t.boolean  "failed",                  :default => false
    t.string   "error_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "option_values_option_values_groups", :id => false, :force => true do |t|
    t.integer "option_value_id"
    t.integer "option_values_group_id"
  end

  add_index "option_values_option_values_groups", ["option_value_id"], :name => "opovg_option_value_id"
  add_index "option_values_option_values_groups", ["option_values_group_id"], :name => "opovg_option_group_id"

  create_table "order_return_requests", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_shipments_factories_concrete", :id => false, :force => true do |t|
    t.integer  "id",                                    :null => false
    t.string   "number",                  :limit => 15
    t.string   "state"
    t.date     "completed_at"
    t.date     "projected_delivery_date"
    t.date     "shipped_at"
    t.text     "array_to_string"
    t.float    "days_to_ship"
    t.integer  "num_items",               :limit => 8
    t.boolean  "shipped_in_7"
    t.boolean  "shipped_before_delivery"
    t.datetime "updated_at"
  end

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
    t.boolean "active",          :default => true
    t.boolean "custom",          :default => false
  end

  add_index "product_color_values", ["product_id"], :name => "index_product_color_values_on_product_id"

  create_table "product_height_range_groups", :force => true do |t|
    t.string   "unit"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_height_ranges", :force => true do |t|
    t.integer  "min"
    t.integer  "max"
    t.string   "unit"
    t.string   "map_to"
    t.integer  "product_height_range_group_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "product_making_options", :force => true do |t|
    t.integer "product_id"
    t.integer "variant_id"
    t.boolean "active",                                                   :default => false
    t.string  "option_type"
    t.decimal "price",                     :precision => 10, :scale => 2
    t.string  "currency",    :limit => 10
  end

  add_index "product_making_options", ["product_id", "active", "option_type"], :name => "index_product_making_options_on_product_id"

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

  create_table "redirected_search_terms", :force => true do |t|
    t.string   "term"
    t.string   "redirect_to"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "refund_requests", :force => true do |t|
    t.integer  "order_id"
    t.integer  "payment_id"
    t.string   "order_number"
    t.string   "payment_ref",             :null => false
    t.string   "currency"
    t.integer  "payment_amount"
    t.string   "acceptance_status"
    t.integer  "requested_refund_amount"
    t.datetime "payment_created_at"
    t.string   "customer_name"
    t.string   "customer_email"
    t.string   "refund_ref"
    t.string   "refund_currency"
    t.string   "refund_success"
    t.integer  "refund_amount"
    t.datetime "refund_created_at"
    t.string   "refund_status_message"
    t.string   "public_key"
    t.string   "secret_key"
    t.string   "api_url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "render3d_images", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "product_id"
    t.integer  "customisation_value_id"
    t.integer  "color_value_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "return_inventory_items", :force => true do |t|
    t.integer  "upc",                            :null => false
    t.string   "style_number"
    t.integer  "available",                      :null => false
    t.string   "vendor",                         :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "active",       :default => true
  end

  add_index "return_inventory_items", ["active", "available"], :name => "index_return_inventory_items_on_active_and_available"
  add_index "return_inventory_items", ["style_number"], :name => "index_return_inventory_items_on_style_number"
  add_index "return_inventory_items", ["upc"], :name => "index_return_inventory_items_on_upc"

  create_table "return_request_items", :force => true do |t|
    t.integer  "order_return_request_id"
    t.integer  "line_item_id"
    t.integer  "quantity"
    t.text     "action"
    t.text     "reason_category"
    t.text     "reason"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "revolution_pages", :force => true do |t|
    t.integer  "template_id"
    t.text     "path"
    t.text     "template_path"
    t.text     "canonical"
    t.text     "redirect"
    t.text     "variables"
    t.datetime "publish_from"
    t.datetime "publish_to"
    t.integer  "parent_id"
    t.integer  "lft",                               :null => false
    t.integer  "rgt",                               :null => false
    t.integer  "depth",          :default => 0,     :null => false
    t.integer  "children_count", :default => 0,     :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "noindex",        :default => false
    t.boolean  "nofollow",       :default => false
    t.string   "product_order"
  end

  add_index "revolution_pages", ["parent_id"], :name => "index_revolution_pages_on_parent_id"
  add_index "revolution_pages", ["path"], :name => "index_revolution_pages_on_path", :unique => true
  add_index "revolution_pages", ["publish_from", "publish_to"], :name => "index_revolution_pages_on_publish_from_and_publish_to"
  add_index "revolution_pages", ["rgt"], :name => "index_revolution_pages_on_rgt"

  create_table "revolution_translations", :force => true do |t|
    t.integer  "page_id"
    t.text     "locale"
    t.text     "title"
    t.text     "meta_description"
    t.text     "heading"
    t.text     "sub_heading"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "revolution_translations", ["locale"], :name => "index_revolution_translations_on_locale"
  add_index "revolution_translations", ["page_id"], :name => "index_revolution_translations_on_page_id"

  create_table "similarities", :force => true do |t|
    t.integer "original_id"
    t.integer "similar_id"
    t.float   "coefficient"
  end

  add_index "similarities", ["original_id"], :name => "index_similarities_on_original_id"
  add_index "similarities", ["similar_id"], :name => "index_similarities_on_similar_id"

  create_table "simple_key_values", :force => true do |t|
    t.string   "key",        :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "simple_key_values", ["key"], :name => "index_simple_key_values_on_key", :unique => true

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
    t.string   "domain",                  :default => "",    :null => false
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
    t.string   "match_policy",             :default => "all"
    t.string   "code"
    t.boolean  "advertise",                :default => false
    t.string   "path"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "eligible_to_custom_order", :default => false
    t.boolean  "eligible_to_sale_order",   :default => false
    t.boolean  "require_shipping_charge",  :default => false
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
    t.integer  "quantity",                                               :null => false
    t.decimal  "price",                    :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "currency"
    t.decimal  "old_price",                :precision => 8, :scale => 2
    t.string   "delivery_date"
    t.jsonb    "customizations"
    t.boolean  "stock"
    t.string   "color"
    t.string   "size"
    t.string   "length"
    t.string   "upc"
    t.integer  "fabric_id"
    t.integer  "return_inventory_item_id"
    t.string   "refulfill_status"
    t.text     "curation_name"
  end

  add_index "spree_line_items", ["fabric_id"], :name => "index_line_item_on_fabric_id"
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

  create_table "spree_masterpass_checkouts", :force => true do |t|
    t.string   "access_token"
    t.string   "transaction_id"
    t.string   "precheckout_transaction_id"
    t.string   "cardholder_name"
    t.string   "account_number"
    t.string   "billing_address"
    t.date     "exp_date"
    t.string   "brand_id"
    t.string   "contact_name"
    t.string   "gender"
    t.date     "birthday"
    t.string   "national_id"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "order_id"
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
  add_index "spree_option_values", ["presentation"], :name => "index_spree_option_values_on_presentation"

  create_table "spree_option_values_groups", :force => true do |t|
    t.integer  "option_type_id"
    t.string   "name"
    t.string   "presentation"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "available_as_taxon", :default => false
  end

  add_index "spree_option_values_groups", ["option_type_id"], :name => "index_spree_option_values_groups_on_option_type_id"

  create_table "spree_option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], :name => "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], :name => "index_spree_option_values_variants_on_variant_id"

  create_table "spree_orders", :force => true do |t|
    t.string   "number",                  :limit => 15
    t.decimal  "item_total",                            :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                                 :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "state"
    t.decimal  "adjustment_total",                      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                         :precision => 10, :scale => 2, :default => 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                            :null => false
    t.datetime "updated_at",                                                                            :null => false
    t.string   "currency"
    t.string   "last_ip_address"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.date     "required_to"
    t.text     "customer_notes"
    t.datetime "projected_delivery_date"
    t.text     "site_version"
    t.boolean  "orderbot_synced"
    t.string   "return_type"
    t.string   "vwo_type"
    t.boolean  "autorefundable"
  end

  add_index "spree_orders", ["completed_at"], :name => "index_spree_orders_on_completed_at"
  add_index "spree_orders", ["created_at"], :name => "index_spree_orders_on_created_at"
  add_index "spree_orders", ["number"], :name => "index_spree_orders_on_number"
  add_index "spree_orders", ["shipment_state"], :name => "index_spree_orders_on_shipment_state"
  add_index "spree_orders", ["state"], :name => "index_spree_orders_on_state"
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

  create_table "spree_product_related_outerwear", :force => true do |t|
    t.integer "outerwear_id"
    t.integer "product_id"
  end

  add_index "spree_product_related_outerwear", ["outerwear_id", "product_id"], :name => "spree_product_related_outerwear_unique_index", :unique => true
  add_index "spree_product_related_outerwear", ["product_id"], :name => "index_spree_product_related_outerwear_on_product_id"

  create_table "spree_products", :force => true do |t|
    t.string   "name",                 :default => "",     :null => false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "permalink"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.integer  "count_on_hand",        :default => 0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "on_demand",            :default => false
    t.boolean  "featured",             :default => false
    t.integer  "position",             :default => 0
    t.boolean  "hidden",               :default => false
    t.integer  "factory_id"
    t.string   "size_chart",           :default => "2014", :null => false
    t.integer  "fabric_card_id"
    t.integer  "category_id"
    t.jsonb    "customizations"
    t.jsonb    "lengths"
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
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "name"
    t.boolean  "sitewide",              :default => false
    t.boolean  "customisation_allowed", :default => false
    t.string   "sitewide_message"
    t.string   "currency",              :default => ""
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
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "position",             :default => 0
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
    t.string   "name",                                                  :null => false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "title"
    t.datetime "published_at"
    t.string   "delivery_period",   :default => "7 - 10 business days"
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
    t.integer  "sign_in_count",                                           :default => 0,      :null => false
    t.integer  "failed_attempts",                                         :default => 0,      :null => false
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
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.string   "spree_api_key",                            :limit => 48
    t.datetime "remember_created_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "sign_up_via"
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
    t.boolean  "automagically_registered",                                :default => false
    t.integer  "active_moodboard_id"
    t.string   "wedding_atelier_signup_step",                             :default => "size"
    t.text     "user_data",                                               :default => "{}",   :null => false
  end

  add_index "spree_users", ["email"], :name => "email_idx_unique", :unique => true

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
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.boolean  "has_international_shipping_fee", :default => false
    t.boolean  "show_duty_fee_notification",     :default => false
  end

  create_table "spree_zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        :default => false
    t.integer  "zone_members_count", :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "style_to_product_height_range_groups", :force => true do |t|
    t.string   "style_number"
    t.integer  "product_height_range_group_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "styles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
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

  create_table "wedding_atelier_event_assistants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "wedding_atelier_event_dresses", :force => true do |t|
    t.integer  "product_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "color_id"
    t.integer  "style_id"
    t.integer  "fabric_id"
    t.integer  "size_id"
    t.integer  "length_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "fit_id"
    t.string   "height"
    t.integer  "likes_count", :default => 0
  end

  create_table "wedding_atelier_event_roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "wedding_atelier_events", :force => true do |t|
    t.string   "event_type"
    t.integer  "number_of_assistants"
    t.date     "date"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "owner_id"
  end

  create_table "wedding_atelier_invitations", :force => true do |t|
    t.string  "user_email"
    t.string  "event_slug"
    t.string  "state",      :default => "pending"
    t.integer "event_id"
    t.integer "inviter_id"
  end

  create_table "wedding_atelier_likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_dress_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "wedding_atelier_likes", ["user_id", "event_dress_id"], :name => "index_wedding_atelier_likes_on_user_id_and_event_dress_id", :unique => true

  create_table "wedding_atelier_user_profiles", :force => true do |t|
    t.integer "spree_user_id"
    t.string  "height"
    t.boolean "trend_updates"
    t.integer "dress_size_id"
  end

  create_table "wedding_atelier_users_event_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "event_role_id"
  end

  create_table "wedding_plannings", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "preferred_time"
    t.string   "session_type"
    t.boolean  "should_contact"
    t.boolean  "should_receive_trend_updates"
    t.string   "timezone"
    t.date     "wedding_date"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

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
