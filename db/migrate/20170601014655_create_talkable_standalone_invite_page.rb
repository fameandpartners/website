class CreateTalkableStandaloneInvitePage < ActiveRecord::Migration
  private def landing_page_properties
    {
      path:             '/invite',
      template_path:    '/statics/landing_page_invite',
      heading:          'Refer Friends, Get A Discount',
      title:            'Refer Friends, Get A Discount',
      meta_description: 'Refer your friends and family to Fame and Partners to get $25 off your next custom, ethically made purchase.'
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
