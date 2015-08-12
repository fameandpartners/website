class AddLimitToLookbook < ActiveRecord::Migration
  def up
    Revolution::Page.all.each do |page|
      if page.get(:lookbook)
        page.variables[:limit] = 99
        page.save!
      end
    end
  end
end
