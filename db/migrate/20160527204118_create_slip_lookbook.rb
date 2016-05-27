class CreateSlipLookbook < ActiveRecord::Migration
  def up
    unless Revolution::Page.exists?(path: '/lookbook/slip-collection')
      page = Revolution::Page.create!(
        path:          '/lookbook/slip-collection',
        template_path: '/lookbook/show',
        variables:     { image_count: 4, lookbook: true, limit: 24 }
      )

      page.translations.create!(
        locale:           'en-US',
        title:            'Slip Collection',
        meta_description: 'Slip Collection',
        heading:          'Slip Collection'
      )

      page.publish!
    end
  end

  def down
    Revolution::Page.where(path: '/lookbook/slip-collection').destroy_all
  end
end
