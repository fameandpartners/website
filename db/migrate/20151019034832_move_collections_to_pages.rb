class MoveCollectionsToPages < ActiveRecord::Migration
  def up

    Spree::OptionValuesGroup.for_colors.available_as_taxon.each do |colour|
      resource_args = {
          site_version: SiteVersion.default,
          color_group:  colour.name
      }
      collection    = Products::CollectionResource.new(resource_args).read

      r_page               = Revolution::Page.new
      r_page.path          = "/dresses/#{colour.name}"
      r_page.template_path = '/products/collections/show'
      r_page.publish_from  = Date.current - 2.months
      banner               = collection.details.banner

      banner.seo_description = collection.details.seo_description
      subheading             = banner.subtitle
      us_translation         = set_banner('en-US', banner, subheading, collection.details)
      aus_translation        = set_banner('en-AU', banner, subheading, collection.details)

      r_page.save
      us_translation.page_id = r_page.id
      us_translation.save
      aus_translation.page_id = r_page.id
      aus_translation.save

    end

    Spree::Taxon.where("parent_id is not null").each do |taxon|
      base_link, permalink = taxon.permalink.split('/')
      next if Revolution::Page.where(path: "/dresses/#{permalink}").first
      r_page               = Revolution::Page.new
      r_page.path          = "/dresses/#{permalink}"
      r_page.template_path = '/products/collections/show'
      r_page.publish_from  = taxon.published_at
      banner               = taxon.banner

      subheading      = (banner.blank? ? nil : banner.description)
      us_translation  = set_banner('en-US', banner, subheading, taxon)
      aus_translation = set_banner('en-AU', banner, subheading, taxon)

      r_page.save

      us_translation.page_id = r_page.id
      us_translation.save
      aus_translation.page_id = r_page.id
      aus_translation.save

    end
  end

  def down
  end

  def set_banner(locale, banner, subheading, taxon)
    banner = Spree::TaxonBanner.new if banner.blank?
    translation = Revolution::Translation.new
    translation.locale = locale
    translation.title = (banner.title.blank? ? taxon.meta_title : banner.title)
    translation.meta_description = case
                                     when !taxon.meta_title.blank?
                                       taxon.meta_title
                                     when !taxon.meta_description.blank?
                                       taxon.meta_description
                                     when !banner.title.blank?
                                       banner.title
                                     else
                                       nil
                                   end
    translation.heading = (banner.title.blank? ? taxon.meta_title : banner.title)
    translation.description = banner.seo_description
    translation.sub_heading = subheading
    translation
  end

end
