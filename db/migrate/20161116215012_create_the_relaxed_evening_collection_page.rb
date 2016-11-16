class CreateTheRelaxedEveningCollectionPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/the-relaxed-evening-collection',
      template_path:    '/landing_pages/the_relaxed_evening_collection',
      pids:             %w().join(','),
      limit:            '5',
      heading:          'The Relaxed Evening Collection',
      title:            'The Relaxed Evening Collection',
      meta_description: 'Easy, effortless evening wear including velvet suits, silk kimonos, corset belts, cocktail dresses, embroidery, and beading.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids] },
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
