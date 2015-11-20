namespace :moodboard_item do
  task :recalculate => :environment do
    MoodboardItem.all.each do |moodboard_item|
      MoodboardItemCalculator.new(moodboard_item).run.save!
    end
  end

  desc 'Migrate from WishlistItems'
  task :migrate_from_wishlist_items => :environment do
    require 'log_formatter'
    require 'ruby-progressbar'

    class MigrateWishlistItemsToMoodboard

      attr_reader :progressbar

      def initialize(logdev: $stdout)
        @logger           = Logger.new(logdev)
        @logger.level     = Logger::INFO
        @logger.formatter = LogFormatter.terminal_formatter

        @progressbar = ProgressBar.create(
              :total => scope.count,
              :format => '%a %e | WishlistItem %c/%C |%w%i|'
            )
      end

      def scope
        WishlistItem.where("spree_product_id IS NOT NULL and product_color_id IS NOT NULL")
      end

      def call
        scope.find_each do |item|
          progressbar.increment

          product_id   = item.spree_product_id
          color_id     = item.product_color_id
          moodboard_id = item.user.moodboards.default_or_create.id

          if MoodboardItem.where(product_id: product_id, color_id: color_id, moodboard_id: moodboard_id).exists?
            next
          end

          pcv_id       = ProductColorValue.where(product_id: product_id, option_value_id: color_id).first.try(:id)

          ev = MoodboardItemEvent.creation.new(
            moodboard_id:           moodboard_id,
            product_id:             product_id,
            product_color_value_id: pcv_id,
            color_id:               color_id,
            user_id:                item.spree_user_id,
            variant_id:             item.spree_variant_id
          )
          ev.save!

        end
      end
    end
    MigrateWishlistItemsToMoodboard.new.call
  end
end

