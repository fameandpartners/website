module WeddingAtelier
  module ApplicationHelper

    def registration?
      controller_name == 'registrations'
    end

    def fancy_facebook_button
      content_tag :div, class: ['text-center','hidden-xs'] do
        link_to fb_auth_path({ return_to: wedding_atelier.events_path}), class: 'btn-facebook-fancy' do
          [
            image_tag('facebook-letter-logo.svg'),
            content_tag(:span, 'Sign up with ', class: 'pre-text'),
            content_tag(:span, 'Facebook', class: 'facebook-text')
          ].join("\n").html_safe
        end
      end
    end

  end
end
