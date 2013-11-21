namespace "db" do
  namespace "populate" do
    desc "create number of dresses with images and properties"
    task site_versions: :environment do
      create_site_versions
    end

    desc "create prices for each site version"
    task site_version_prices: :environment do
      SiteVersion.where(default: false).each do |site_version|
        site_version.update_exchange_rate
      end
    end
  end
end

def create_site_versions
  create_site_version('australia', 'au', 'en-AU')
  create_site_version('usa', 'us', 'en-US')
end

def create_site_version(name, code, locale)
  args = {
    permalink: code,
    name: name,
    zone_id: get_zone_id(name),
    currency: 'AUD',
    locale: locale,
    default: code.downcase == 'us'
  }

  site_version = SiteVersion.where(zone_id: args[:zone_id], permalink: args[:permalink]).first
  if site_version.blank?
    site_version = SiteVersion.create(args)
  end
  site_version
end

def get_zone_id(name)
  zone = Spree::Zone.where("lower(name) = :name", name: name).first
  zone.id if zone.present?

  Spree::Zone.create(name: name)
end
