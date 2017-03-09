module Importers
  class FactoryImporter < FileImporter
    def import
      preface

      csv = CSV.read(csv_file, headers: true, skip_blanks: true)

      progress = ProgressBar.create(total: csv.count)

      Spree::Product.transaction do

        csv.each do |row|
          row_success = false
          if( row['style'].present? )
            row_success = update_single_sku( row['style'].downcase, row['factory'].to_s.capitalize, row['name'].to_s )
          elsif ( row['style_number'].present? )
            row_success = update_entire_style( row['style_number'].downcase, row['factory'].to_s.capitalize )
          else
            raise "Unknown CSV Format"
          end
          if row_success
            progress.increment
          end
        end
        progress.finish
      end
      info "Done"
    end
    private

    def update_entire_style( style_number, factory_name )
      success = true
      GlobalSku.where( "style_number ILIKE ?", style_number ).each do |global_sku|
        success = false unless update_single_sku( global_sku.sku, factory_name )
      end
      success
    end
    
    def update_single_sku( sku, factory_name, name = nil )
      variant = Spree::Variant.where("spree_variants.sku ILIKE ?", "#{sku}%").first
      
      if( name.present? )
        product = Spree::Product.where('lower(name) = ?', name.downcase).first 
      else
        product = nil
      end
      
      unless variant || product
        warn "Skipping: No Product found for SKU='#{sku}' or name='#{name}'"
        success = false
      else
        factory = Factory.find_or_create_by_name(factory_name)

        product ||= variant.product
        old_factory_name = product.property(:factory_name)

        product.factory = factory
        set_property    = product.set_property(:factory_name, factory_name)
        set_object      = product.save
      end
      return set_property && set_object
    end
    
  end
end
