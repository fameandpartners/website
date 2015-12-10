class UpdateBestSellerPageAgain < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: '/dresses/best-sellers').first
    if page.present?
      page.template_path = '/products/collections/show'
      page.variables["lookbook"] = false
      page.variables["curated"]  = true
      page.save!
    end
  end
end
