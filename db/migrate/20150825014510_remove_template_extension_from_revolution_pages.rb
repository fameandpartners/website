class RemoveTemplateExtensionFromRevolutionPages < ActiveRecord::Migration
  class Revolution::Page < ActiveRecord::Base
  end

  def up
    Revolution::Page.find_each do |page|
      page.template_path = page.template_path.gsub '.html.slim', ''
      page.save
    end
  end

  def down
    Revolution::Page.find_each do |page|
      page.template_path += '.html.slim'
      page.save
    end
  end
end
