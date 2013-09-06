require 'csv'
require 'ostruct'

module Spree
  module Admin
    class UserStyleProfilesController < BaseController
      def download
        send_data csv_data, filename: 'user_style_profiles.csv', type: :csv
      end

      private

      def model_class
        ::UserStyleProfile
      end

      def users_with_style_profile
        user_ids = UserStyleProfile.select('distinct(user_id) as user_id').map(&:user_id)
        Spree::User.includes(:style_profile).find(user_ids)
      end

      def csv_data
        @csv_data ||= generate_csv_data
      end

      def generate_csv_data
        data = CSV.generate(:col_sep => ';') do |csv|
          csv << [
            'user id', 
            'user fname',
            'user lname',
            'user email',
            'user sign up date',
            'user last login',
            'glam',
            'girly',
            'classic',
            'edgy',
            'bohemian',
            'sexiness',
            'fashionability',
            'nail colours',
            'brands',
            'trends',
            'hair colour',
            'skin colour',
            'body shape',
            'typical size',
            'bra size',
            'colours'
          ]

          users_with_style_profile.each do |user|
            csv << [
              user.id,
              user.first_name,
              user.last_name,
              user.email,
              user.created_at.to_s(:db),
              user.last_sign_in_at.to_s(:db)] + style_profile_array(user.style_profile)
          end
        end

        return data
      end

      def style_profile_array(style_profile)
        return '' if style_profile.blank?
        result = ''

        style_profile.attributes.except(
          *%w{id user_id created_at updated_at serialized_answers}
        ).values.map do |value|
          if value.respond_to?(:join)
            value.join(', ')
          else
            value.to_s
          end
        end
      end
    end
  end
end
