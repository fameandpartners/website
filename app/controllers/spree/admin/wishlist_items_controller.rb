require 'csv'
require 'ostruct'

module Spree
  module Admin
    class WishlistItemsController < BaseController
      def download
        puts csv_data
        send_data csv_data, filename: 'wishlist_details.csv', type: :csv
      end

      private

      def model_class
        ::WishlistItem
      end

      def csv_data
        @csv_data ||= generate_csv_data
      end

      def generate_csv_data
        data = CSV.generate do |csv|
          csv << [
            'product name',
            'product sku',
            'details',
            'user email',
            'user fname',
            'user lname',
            'date added'
          ]

          WishlistItem.includes(:user, :product, :variant => [:option_values]).each do |item|
            begin
              csv << [
                item.product.try(:name),
                item.product.try(:sku),
                item_details(item),
                item.user.email,
                item.user.first_name,
                item.user.last_name,
                item.created_at.to_s(:db)
              ]
            rescue
            end
          end
        end

        return data
      end

      # return variant specific details
      def item_details(item)
        variant = item.variant
        return '' if variant.blank? || variant.is_master?
        [
          variant.dress_color.try(:presentation),
          variant.dress_size.try(:presentation),
          variant.sku
        ].delete_if(&:blank?).join(', ')
      end
    end
  end
end
