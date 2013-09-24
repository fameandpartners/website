namespace "db" do
  namespace "populate" do
    desc "create Length/NeckLine customisation categories"
    task customisation_categories: :environment do
      customisations = [
        {name: 'length', values: %w[short mid-length high]},
        {name: 'neck-line', values: %w[vneck round straight]}
      ]
      customisations.each do |attrs|
        attrs[:presentation] ||= attrs[:name].underscore.humanize.split.map(&:capitalize).join(' ')
        values = attrs.delete(:values)
        category = CustomisationType.where(attrs).first_or_create
        (values - category.customisation_values.map(&:name)).each do |name|
          presentation = name.underscore.humanize.split.map(&:capitalize).join(' ')
          category.customisation_values.create(name: name, presentation: presentation)
        end
      end
    end
  end
end
