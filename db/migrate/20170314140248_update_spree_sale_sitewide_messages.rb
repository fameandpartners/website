class UpdateSpreeSaleSitewideMessages < ActiveRecord::Migration
  def change
    Spree::Sale.update_all(sitewide_message: "{discount} OFF SITEWIDE")
  end
end
