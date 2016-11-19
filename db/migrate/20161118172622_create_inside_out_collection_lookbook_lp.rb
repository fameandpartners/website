class CreateInsideOutCollectionLookbookLp < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/inside-out-collection',
      template_path:    '/landing_pages/inside_out_collection',
      pids:             %w().join(','),
      heading:          'The Inside Out Collection',
      title:            'The Inside Out Collection',
      limit:            '99',
      meta_description: 'The INSIDE\OUT Collection. Effortless evening wear designed to make you feel beautiful from the inside out.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], image_count: 7 },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
      page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    end
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end

end
