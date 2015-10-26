require 'csv'
namespace :hacks do
  def printed?
    /Print|Animal|Aztec|Baroque|Brocade|Check|Checkered|Conversational|Digital|Floral|Geometric|Gingham|Ikat|Leopard|Monochrome|Ombre|Paisley|Patchwork|Photographic|Plaid|Polka Dot|Psychedelic|Scarf|Spots|Stripes|Tie Dye|Tribal|Tropical|Victorian|Watercolour|Zebra/i
  end

  def beading?
    /Beading|Embellishment|Sequin/i
  end

  def embroidered?
    /Embroid/i
  end

  desc 'Export a list of products '
  task :making => :environment do

    # slow_categories = %w{bead print emroider brocade}
    CSV.open('making.csv', 'wb') do |csv|
      csv << ['name','style', 'beaded', 'printed', 'embroidered']

      Spree::Product.all.each do |product|
        beaded = product.description =~ beading?
        printed = product.description =~ printed?
        embroidered = product.description =~ embroidered?

        if beaded.present? || printed.present? || embroidered.present?
          csv << [product.name, product.sku, beaded.present?, printed.present?, embroidered.present?]
        end
      end

    end


  end
end
