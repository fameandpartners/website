class CreateInternshipPage < ActiveRecord::Migration
  private def landing_page_properties
    {
      path:             '/internship',
      template_path:    '/statics/landing_page_internship',
      heading:          'Fashion IT Girl Internship',
      title:            'Fashion IT Girl Internship',
      meta_description: 'Enter Fame and Partners Fashion\' IT Girl Competition to win a paid fashion internship in Los Angeles and $20,000 in other prizes!'
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
