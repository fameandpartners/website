class UpdateHighContrastLandingPage < ActiveRecord::Migration
  class Revolution::Page < ActiveRecord::Base
  end

  def up
    if contrast_page = Revolution::Page.find_by_path('/high-contrast')
      contrast_page.update_column(:template_path, '/landing_pages/high_contrast_collection.html.slim')
      contrast_page.save
    end
  end
end
