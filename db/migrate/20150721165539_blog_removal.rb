class BlogRemoval < ActiveRecord::Migration
  def up
    remove_admin_roles

    remove_related_columns

    drop_blog_tables

    drop_acts_as_taggable_tables
  end

  def down
  end

  private

    def remove_admin_roles
      roles = ['Blog Moderator', 'Blog Admin']
      Spree::Role.where(name: roles).destroy_all
    end

    def blog_tables
      %w{
        blog_authors
        blog_categories
        blog_celebrities
        blog_celebrity_photo_votes
        blog_celebrity_photos
        blog_events
        blog_post_photos
        blog_posts
        blog_preferences
        blog_promo_banners
      }
    end

    def drop_blog_tables
      blog_tables.each do |table_name|
        if ActiveRecord::Base.connection.table_exists? table_name
          drop_table table_name
        end
      end
    end

    def drop_acts_as_taggable_tables
      tables = %w{
        taggings
        tags
      }
      tables.each do |table_name|
        if ActiveRecord::Base.connection.table_exists? table_name
          drop_table table_name
        end
      end
    end

    def remove_related_columns
      [
        [:spree_users, :description],
        [:spree_users, :slug]
      ].each do |table_name, column_name|
        if column_exists?(table_name, column_name)
          remove_column table_name, column_name
        end
      end
    end
end
