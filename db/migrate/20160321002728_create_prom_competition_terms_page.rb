class CreatePromCompetitionTermsPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/prom-competition-terms',
      :template_path => '/statics/prom_competition_terms'
    )
    
  page.translations.create!(:locale => 'en-US', :title => 'Partners In Crime Sweepstakes Official Rules', :meta_description => 'Partners In Crime Sweepstakes Official Rules', :heading => 'Partners In Crime Sweepstakes Official Rules')
  page.publish!
  end

  def down
    Revolution::Page.where(:path => '/prom-competition-terms').delete_all
  end
end
