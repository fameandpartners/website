# run locally:
# bundle exec rake sitemap:create
# bundle exec rake sitemap:refresh - works too, but ping google/bing
# - if you wish to format the XML into something more human readable, you can use the command `xmllint --format sitemap.xml`
# => Note: on production, if you run the sitemap:create rake task, it'll automatically ping search engines
#

unless Rails.env.development?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    :aws_access_key_id => configatron.aws.s3.access_key_id,
    :aws_secret_access_key => configatron.aws.s3.secret_access_key,
    :fog_provider => 'AWS',
    :fog_directory => configatron.aws.s3.bucket,
    :fog_region => configatron.aws.s3.region
  )
end

SitemapGenerator::Interpreter.send :include, PathBuildersHelper

SitemapGenerator::Interpreter.class_eval do
  def absolute_url(path = '/')
    path = ('/' + path).gsub(/\/+/, '/')
    url = "#{ SitemapGenerator::Sitemap.default_host }#{ path }"
  end

  def site_versions
    @_site_version ||= SiteVersion.where(default: false).to_a
  end

  # make links for all site versions
  # version for default - without prefix
  # <xhtml:link rel="alternate" hreflang="en" href="http://example.com" />
  # <xhtml:link rel="alternate" hreflang="en-AU" href="http://example.com/au" />
  def build_alternates(path)
    alternates = [{ href: absolute_url(path), lang: 'en-US', nofollow: false }]

    alternates + site_versions.map do |site_version|
      {
        href: absolute_url('/' + site_version.permalink + path), lang: site_version.locale, nofollow: false  
      }
    end
  end

  def map_taxon_products_images(taxon_id)
    taxon_products = Spree::Taxon.find(taxon_id).products.active
    cropped_products_images_for_sitemap(taxon_products)
  end

  # A color group is a Spree::OptionValue
  def map_color_group_products_images(color_id)
    products_with_color = Spree::Product.active.includes(option_types: :option_values).where('spree_option_values.id' => color_id)
    cropped_products_images_for_sitemap(products_with_color)
  end

  private

  def cropped_products_images_for_sitemap(product_array)
    images = []

    product_array.each do |product|
      image = Repositories::ProductImages.new(product: product).read(cropped: true)
      images.push({ loc: image.large, title: product.name }) if image
    end

    images
  end
end

sitemap_options = {
  compress: Rails.env.production?,
  default_host: "http://#{configatron.host}",
  sitemaps_host: "http://#{configatron.aws.host}",
  include_root: false,
  sitemaps_path: 'sitemap'
}

SitemapGenerator::Sitemap.create(sitemap_options) do
  # Common pages
  add '/assets/returnform.pdf', priority: 0.5

  # Creating sitemaps for each site version
  SiteVersion.find_each do |site_version|

    sitemap_group_options = {
      include_root: true,
      default_host: "http://#{configatron.host}/#{site_version.to_param}",
      filename: site_version.permalink
    }

    statics_pages = [
      '/about', '/why-us', '/privacy',
      '/style-consultation', '/fame-chain',
      '/fashionitgirl2015',
      '/bridesmaid-dresses', '/sale-dresses',
      '/unidays'
    ]

    group(sitemap_group_options) do

      # Products pages
      Spree::Product.active.each do |product|
        images_repo = Repositories::ProductImages.new(product: product)

        add(collection_product_path(product), {
          priority: 0.8,
          images: images_repo.filter(cropped: false).map { |img| { loc: img.large, title: product.name } }
        })
      end

      # Events
      Repositories::Taxonomy.read_events.each do |taxon|
        add(build_taxon_path(taxon.name), {
          priority: 0.7,
          images: map_taxon_products_images(taxon.id)
        })
      end

      # Collections
      Repositories::Taxonomy.read_collections.each do |taxon|
        add(build_taxon_path(taxon.name), {
          priority: 0.7,
          images: map_taxon_products_images(taxon.id)
        })
      end

      # Styles
      Repositories::Taxonomy.read_styles.each do |taxon|
        add(build_taxon_path(taxon.name), {
          priority: 0.7,
          images: map_taxon_products_images(taxon.id)
        })
      end

      # Color Groups
      Repositories::ProductColors.color_groups.each do |color_group|
        path = colour_path(color_group.name)
        add(path, {
          priority: 0.7,
          images: map_color_group_products_images(color_group.id)
        })
      end

      # Static pages
      statics_pages.each do |page_path|
        add page_path, priority: 0.5
      end
    end
  end
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines("#{sitemap_options[:sitemaps_host]}/#{sitemap_options[:sitemaps_path]}/sitemap.xml.gz")

  # Delete local Sitemap files. They all were uploaded to S3
  FileUtils.rm_rf File.join(SitemapGenerator::Sitemap.public_path, SitemapGenerator::Sitemap.sitemaps_path)
end
