class AddVariableToBrideMaidsPage < ActiveRecord::Migration
  def up
    p = Revolution::Page.where(path: "/dresses/bridesmaid").first
    if p.present?
      p.variables[:remove_excluded_from_site_logic] = true
      p.save!
    end
  end

  def down
    p = Revolution::Page.where(path: "/dresses/bridesmaid").first
    if p.present?
      p.variables[:remove_excluded_from_site_logic] = nil
      p.save!
    end
  end
end
