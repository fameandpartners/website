module Marketing
  module Feeds
    class ShopstyleController < ActionController::Base
      SHOPSTYLE_FEED_FILE_PATH  = '/feeds/au/products/shopstyle.xml'.freeze
      SHOPSTYLE_FEED_BUCKET_URL = ['https://s3.amazonaws.com/', ENV['AWS_S3_BUCKET']].join.freeze
      SHOPSTYLE_FEED_URL        = [SHOPSTYLE_FEED_BUCKET_URL, SHOPSTYLE_FEED_FILE_PATH].join.freeze

      def au_feed
        redirect_to SHOPSTYLE_FEED_URL, status: :moved_permanently
      end
    end
  end
end
