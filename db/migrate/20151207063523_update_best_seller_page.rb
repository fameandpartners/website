class UpdateBestSellerPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: '/dresses/best-sellers').first
    if page.present?
      page.template_path = '/lookbook/show.html.slim'
      page.variables["lookbook"] = true
      page.variables["image_count"] = 20
      page.save!
    end
  end
end
