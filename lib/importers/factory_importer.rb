module Importers
  class FactoryImporter < FileImporter
    def import
      preface

      csv = CSV.read(csv_file, headers: true, skip_blanks: true)

      progress = ProgressBar.create(total: csv.count)

      Spree::Product.transaction do
        csv.each do |row|
          sku          = row['style'].downcase
          name         = row['name'].to_s
          factory_name = row['factory'].to_s.capitalize

          product = Spree::Product.where('lower(name) = ?', name.downcase).first
          variant = Spree::Variant.where("spree_variants.sku ILIKE '#{sku}%'").first

          unless variant || product
            warn "Skipping: No Product found for SKU='#{sku}' or name='#{name}'"
            next
          end

          factory = Factory.find_or_create_by_name(factory_name)

          product ||= variant.product
          old_factory_name = product.property(:factory_name)

          product.factory = factory
          set_property    = product.set_property(:factory_name, factory_name)
          set_object      = product.save

          if set_property && set_object
            progress.increment
            # info "#{green("OK")} sku=#{sku} name=#{name} factory=#{old_factory_name} -> #{factory_name}"
          end
        end
        progress.finish
      end
      info "Done"
    end
  end
end
