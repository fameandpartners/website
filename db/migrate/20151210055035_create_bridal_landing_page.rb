class CreateBridalLandingPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.exists?(:path => '/bridal-dresses')
      page = Revolution::Page.create(
        :path => '/bridal-dresses',
        :template_path => '/landing_pages/bridal_dresses.html.slim'
      )
      page.publish!
      page.translations.create!(:locale => 'en-US', :title => 'Bridal Dresses', :meta_description => 'Bridal Dresses', :heading => 'Bridal Dresses')
    end
  end

  def down
    Revolution::Page.where(:path => '/bridal-dresses').delete_all
  end
end
