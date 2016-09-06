class UpdateFameweddingsTemplateAndPath < ActiveRecord::Migration
  def up
    if (old_page = Revolution::Page.where(path: '/fameweddings/bridesmaid').first)
      new_page               = old_page.dup
      new_page.template_path = '/landing_pages/fame_weddings'
      new_page.path          = '/fameweddings'

      old_page.translations.each do |translation|
        new_page.translations << translation.dup
      end

      new_page.save
    end
  end

  def down
    if (page = Revolution::Page.where(path: '/fameweddings').first)
      page.destroy
    end
  end
end
