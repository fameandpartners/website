module Spree
  module WeddingAtelier
    module ApplicationHelper

      def registration?
        controller_name == 'registrations'
      end

      def fancy_facebook_button(pre_text = 'Log in')
        content_tag :div, class: ['text-center','hidden-xs'] do
          link_to fb_auth_path({ return_to: wedding_atelier_events_path}), class: 'btn-facebook-fancy' do
            [
              image_tag('facebook-letter-logo.svg'),
              content_tag(:span, pre_text, class: 'pre-text'),
              ' ',
              content_tag(:span, 'Facebook', class: 'facebook-text')
            ].join("\n").html_safe
          end
        end
      end

      def dress_size_grid(form, dress_sizes)
        content_tag :div, class: 'dress-sizes' do
          content_tag :ul do
            items = []
            dress_sizes.each do |size|
              item = content_tag :li do
                [
                  form.radio_button(:dress_size, "#{@site_version}/#{size}"),
                  form.label(:dress_size, size, value: "#{@site_version}/#{size}")
                ].join("\n").html_safe
              end
              items.push item
            end
            items.join("\n").html_safe
          end
        end
      end

    end
  end
end
