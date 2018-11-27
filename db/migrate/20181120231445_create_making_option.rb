class CreateMakingOption < ActiveRecord::Migration
  def change
    create_table :making_options do |t|
      t.string :code
      t.string :name
      t.string :description

      t.string :delivery_period
      t.string :cny_delivery_period

      t.integer :making_time_business_days
      t.integer :cny_making_time_business_days

      t.decimal :flat_price_usd, :precision => 8, :scale => 2
      t.decimal :flat_price_aud, :precision => 8, :scale => 2
      t.decimal :percent_price_usd, :precision => 8, :scale => 2
      t.decimal :percent_price_aud, :precision => 8, :scale => 2

      t.integer :position

      t.timestamps
    end

    add_column :product_making_options, :making_option_id, :integer
    add_column :product_making_options, :default, :boolean

    MakingOption.find_or_create_by_code('M7D').update_attributes(name: 'Super Express Delivery', description: 'Estimated Delivery in 5 - 7 days', delivery_period: '5 - 7 days', cny_delivery_period: '', making_time_business_days: 2, cny_making_time_business_days: '', flat_price_usd: 29, flat_price_aud: 29, percent_price_usd: nil, percent_price_aud: nil, position: 10)
    MakingOption.find_or_create_by_code('M10D').update_attributes(name: 'Super Express Delivery', description: 'Estimated Delivery in 7 - 10 days', delivery_period: '7 - 10 days', cny_delivery_period: '', making_time_business_days: 5, cny_making_time_business_days: '', flat_price_usd: 9, flat_price_aud: 9, percent_price_usd: nil, percent_price_aud: nil, position: 20)
    MakingOption.find_or_create_by_code('M3W').update_attributes(name: 'Express Delivery', description: 'Estimated Delivery in 2 - 3 weeks', delivery_period: '2 - 3 weeks', cny_delivery_period: '', making_time_business_days: 10, cny_making_time_business_days: '', flat_price_usd: 9, flat_price_aud: 9, percent_price_usd: nil, percent_price_aud: nil, position: 30)
    MakingOption.find_or_create_by_code('M10W').update_attributes(name: 'Standard Delivery', description: 'Estimated Delivery in 6 - 10 weeks', delivery_period: '8 - 10 weeks', cny_delivery_period: '', making_time_business_days: 45, cny_making_time_business_days: '', flat_price_usd: nil, flat_price_aud: nil, percent_price_usd: nil, percent_price_aud: nil, position: 40)
    MakingOption.find_or_create_by_code('M6W').update_attributes(name: 'Standard Delivery', description: 'Estimated Delivery in 6 weeks', delivery_period: '6 weeks', cny_delivery_period: '', making_time_business_days: 30, cny_making_time_business_days: '', flat_price_usd: nil, flat_price_aud: nil, percent_price_usd: 0, percent_price_aud: 0, position: 50)

    ProductMakingOption.where(option_type: 'fast_making').update_all(making_option_id: MakingOption.find_by_code('M3W').id)
    ProductMakingOption.where(option_type: 'free_fast_making').update_all(making_option_id: MakingOption.find_by_code('M3W').id)
    ProductMakingOption.where(option_type: 'slow_making').update_all(making_option_id: MakingOption.find_by_code('M6W').id, default: true)
    ProductMakingOption.where(option_type: 'super_fast_making').update_all(making_option_id: MakingOption.find_by_code('M10D').id)

    grouped = ProductMakingOption.where(active: true).group_by{|pmo| [pmo.product_id, pmo.making_option_id] }
    grouped.values.each do |duplicates|
      duplicates.shift
      duplicates.each{|double| double.destroy}
    end


    Spree::Taxon.find_by_permalink("6-10-week-delivery")&.products&.each do |p|
      default_pmo = p.making_options.where(default: true).first
      default_pmo.making_option = MakingOption.find_or_create_by_code('M10W')
      default_pmo.save!
    end
    

    rename_column :product_making_options, :option_type, :old_option_type
    rename_column :product_making_options, :price, :old_price
    rename_column :product_making_options, :currency, :old_currency
    rename_column :product_making_options, :variant_id, :old_variant_id
    rename_column :spree_taxons, :delivery_period, :old_delivery_period
  end
end
 