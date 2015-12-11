class CreateLetsPartyLandingPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.exists?(:path => '/lets-party')
      page = Revolution::Page.create(
        :path => '/lets-party',
        :template_path => '/landing_pages/lets_party_dresses.html.slim'
      )
      page.publish!
      page.translations.create!(:locale => 'en-US', :title => 'NYE Party Dresses', :meta_description => 'NYE Party Dresses', :heading => 'Party Season')
    end
  end

  def down
    Revolution::Page.where(:path => '/lets-party').delete_all
  end
end
