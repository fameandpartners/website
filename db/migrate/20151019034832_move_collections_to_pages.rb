class MoveCollectionsToPages < ActiveRecord::Migration
  def up
    Spree::Taxon.where("parent_id is not null").each do |taxon|
      base_link, permalink = taxon.permalink.split('/')
      next if Revolution::Page.where(path: "/dresses/#{permalink}").first
      r_page = Revolution::Page.new
      r_page.path = "/dresses/#{permalink}"
      r_page.template_path = '/products/collections/show'
      r_page.publish_from = taxon.published_at
      banner = taxon.banner
      banner = Spree::TaxonBanner.new if banner.blank?

      us_translation = Revolution::Translation.new
      us_translation.locale = 'en-US'
      us_translation.title = (banner.title.blank? ? taxon.meta_title : banner.title)
      us_translation.meta_description = case
                                          when !taxon.meta_description.blank?
                                            taxon.meta_description
                                          when !taxon.meta_title.blank?
                                            taxon.meta_title
                                          when !banner.title.blank?
                                            banner.title
                                          else
                                            nil
                                        end
      us_translation.heading = (banner.title.blank? ? taxon.meta_title : banner.title)
      us_translation.description = banner.seo_description
      us_translation.sub_heading = banner.description

      aus_translation = Revolution::Translation.new
      aus_translation.locale = 'en-AU'
      aus_translation.title = (banner.title.blank? ? taxon.meta_title : banner.title)
      aus_translation.meta_description = case
                                           when !taxon.meta_description.blank?
                                             taxon.meta_description
                                           when !taxon.meta_title.blank?
                                             taxon.meta_title
                                           when !banner.title.blank?
                                             banner.title
                                           else
                                             nil
                                         end
      aus_translation.heading = (banner.title.blank? ? taxon.meta_title : banner.title)
      aus_translation.description = banner.seo_description
      aus_translation.sub_heading = banner.description

      r_page.save

      us_translation.page_id = r_page.id
      us_translation.save
      aus_translation.page_id = r_page.id
      aus_translation.save

    end
  end

  def down
  end
end
