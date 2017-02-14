module WeddingAtelier
  module RegistrationsHelper
    def registration?
      controller_name == 'registrations'
    end

    def fancy_facebook_button(pre_text = 'Log in')
      content_tag :div, class: ['text-center','hidden-xs'] do
        link_to fb_auth_path({ return_to: wedding_atelier.events_path}), class: 'btn-facebook-fancy' do
          [
            image_tag('facebook-letter-logo.svg'),
            content_tag(:span, pre_text, class: 'pre-text'),
            ' ',
            content_tag(:span, 'Facebook', class: 'facebook-text')
          ].join("\n").html_safe
        end
      end
    end

    def signup_progress_marker(current_step)
      signup_steps = %w(new size details invite)
      content_tag :ul, class: 'steps' do
        highlight_class = 'current'
        signup_steps.map.with_index do |step, index|
          step_mark = [content_tag(:li, "0#{index + 1}", class: highlight_class)]
          if current_step == step
            step_mark << content_tag(:span, '', class: 'dash')
            highlight_class = ''
          end
          step_mark
        end.join("\n").html_safe
      end.html_safe
    end

    def dress_size_grid(form, dress_sizes)
      content_tag :div, class: 'dress-sizes' do
        content_tag :ul do
          grouped_sizes = dress_sizes.each_slice(4).to_a
          groups = grouped_sizes.map do |group|
            content_tag :div, class: 'sizing-row' do
              items = group.map do |size|
                parsed_size = size.name.match(/#{@site_version}(\d+)/i)[1]
                content_tag :li do
                  [
                    form.radio_button(:dress_size_id, size.id, 'data-no-error' => true),
                    form.label(:dress_size_id, "#{@site_version.upcase} #{parsed_size}", value: size.id, 'data-no-error': true)
                  ].join("\n").html_safe
                end
              end
              items.join("\n").html_safe
            end
          end
          groups.join("\n").html_safe
        end
      end
    end
  end
end
