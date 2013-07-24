namespace "db" do
  namespace "populate" do
    desc "create number of dresses with images and properties"
    task states: :environment do
      countries_with_states.each do |country_name, states|
        country = Spree::Country.where(iso_name: country_name).first
        next if country.blank?

        states.each do |name, abbr|
          country.states.where(name: name, abbr: abbr).first_or_create
        end
      end
    end

    desc "update prices in db"
    task currency: :environment do
      currency = Spree::Config.currency

      Spree::LineItem.update_all('currency' => currency)
      Spree::Order.update_all('currency' => currency)
      Spree::Price.update_all('currency' => currency)
      Spree::Variant.update_all('cost_currency' => currency)
    end
  end

  def countries_with_states
    {
      'AUSTRALIA' => australia_states
    }
  end

  def australia_states
    [
      ['Australian Capital Territory',  'ACT'],
      ['New South Wales', 'NSW'],
      ['Northern Territory' , 'NT'],
      ['Queensland', 'QLD'],
      ['South Australia', 'SA'],
      ['Tasmania', 'TAS'],
      ['Victoria', 'VIC'],
      ['Western Australia', 'WA']
    ]
  end
end
