class AddMissingIndexes < ActiveRecord::Migration
  def up
    add_index_if_not_exists :answer_taxons, [:taxon_id, :answer_id]

    add_index_if_not_exists :bridesmaid_party_events, [:spree_user_id]
    add_index_if_not_exists :bridesmaid_party_members, [:event_id]
    add_index_if_not_exists :bridesmaid_party_members, [:spree_user_id]

    add_index_if_not_exists :celebrity_inspirations, [:spree_product_id]
    add_index_if_not_exists :celebrity_moodboard_items, [:celebrity_id]

    add_index_if_not_exists :customisation_values, [:product_id]

    add_index_if_not_exists :email_notifications, [:spree_user_id, :code]

    add_index_if_not_exists :facebook_data, [:spree_user_id]

    add_index_if_not_exists :line_item_personalizations, [:line_item_id]

    add_index_if_not_exists :moodboard_items, [:spree_product_id, :active]

    add_index_if_not_exists :option_values_option_values_groups, [:option_value_id], name: :opovg_option_value_id
    add_index_if_not_exists :option_values_option_values_groups, [:option_values_group_id], name: :opovg_option_group_id

    add_index_if_not_exists :payment_requests, [:order_id]
    add_index_if_not_exists :payment_requests, [:token]

    add_index_if_not_exists :product_accessories, [:spree_product_id]
    add_index_if_not_exists :product_accessories, [:style_id]

    add_index_if_not_exists :product_color_values, [:product_id]

    add_index_if_not_exists :product_reservations, [:user_id]

    add_index_if_not_exists :product_videos, [:spree_product_id]

    add_index_if_not_exists :spree_option_values, [:option_type_id]

    add_index_if_not_exists :spree_option_values_groups, [:option_type_id]

    add_index_if_not_exists :spree_product_option_types, [:product_id]
    add_index_if_not_exists :spree_product_option_types, [:option_type_id]

    add_index_if_not_exists :spree_taxon_banners, [:spree_taxon_id]

    add_index_if_not_exists :wishlist_items, [:spree_user_id]
    add_index_if_not_exists :wishlist_items, [:spree_product_id]
  end

  def down
    # do nothing
  end

  def add_index_if_not_exists(table_name, columns, options = {})
    if index_exists?(table_name, columns, options)
      say "already exists index for #{ table_name } #{ columns.inspect }"
    else
      add_index table_name, columns, options
    end
  end
end
