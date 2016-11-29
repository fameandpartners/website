module Spree
  module WeddingAtelier
    module ApplicationHelper
      def registration?
        controller_name == 'registrations'
      end

      def fancy_facebook_button
        content_tag :div, class: 'text-center hidden-xs' do
          link_to fb_auth_path, class: 'btn-facebook-fancy' do
            content_tag :span, 'Sign in with', class: 'pre-text'
            content_tag :span, 'Facebook', class: 'facebook-text'
          end
        end
      end

    end
  end
end
