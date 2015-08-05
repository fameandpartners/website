module Spree
  module Admin
    module BaseHelper
      def link_to_remove_fields(name, f, options = {})
        name = '' if options[:no_text]
        options[:class] = '' unless options[:class]
        options[:class] += 'no-text with-tip' if options[:no_text]
        url = f.object.persisted? ? options[:url] || [:admin, f.object] : '#'
        link_options = {:class => "remove_fields #{options[:class]}", :data => {:action => 'remove' }.merge(options.delete(:data) || {}), :title => t(:remove)}
        link_to_with_icon('icon-trash', name, url, link_options.merge(options[:html] || {})) + f.hidden_field(:_destroy)
      end

      def customisations_values_json
        CustomisationType.all.as_json(only: :id, include: {customisation_values: {only: [:id, :presentation]}})
      end

      # updated code from spree::base_helper#available_countries
      def available_countries
        Spree::Zone.all.map do |checkout_zone|
          if checkout_zone && checkout_zone.kind == 'country'
            checkout_zone.country_list
          else
            []
          end
        end.flatten.sort_by{|country| country.name }
      end
    end
  end
end
