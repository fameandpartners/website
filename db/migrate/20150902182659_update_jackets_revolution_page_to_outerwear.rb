class UpdateJacketsRevolutionPageToOuterwear < ActiveRecord::Migration
  class Revolution::Page < ActiveRecord::Base
  end

  def up
    if jackets_page = Revolution::Page.find_by_path('/jackets')
      jackets_page.update_column(:path, '/dresses/outerwear')
      jackets_page.update_column(:template_path, '/products/outerwear/collection')
      jackets_page.save
    end
  end

  def down
    if outerwear_page = Revolution::Page.find_by_path('/dresses/outerwear')
      outerwear_page.update_column(:path, '/jackets')
      outerwear_page.update_column(:template_path, '/products/jackets/collection')
      outerwear_page.save
    end
  end
end
