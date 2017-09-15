class CreateItGirlCompetitionPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/it-girl',
      template_path:        '/statics/landing_page_it_girl_competition',
      heading:              'Win a paid internship in LA',
      title:                'Win a paid internship in LA',
      meta_description:     'Win $20,000 in prizes and a paid Los Angeles fashion internship with Fame and Partners. Enter now!',
      curated:              'true',
      limit:                3,
      lookbook:             'true',
      pids:                 %w(1339-red 1135-black 1341-burgundy).join(',')
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        curated: landing_page_properties[:curated],
        hide_pagination_link: landing_page_properties[:hide_pagination_link],
        limit: landing_page_properties[:limit],
        lookbook: landing_page_properties[:lookbook],
        pids: landing_page_properties[:pids]
      },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
