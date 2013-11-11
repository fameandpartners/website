class AddExchangeRateToSiteVersion < ActiveRecord::Migration
  def up
    add_column :site_versions, :exchange_rate_timestamp, :date, after: :currency
    add_column :site_versions, :exchange_rate, :decimal, default: 1, after: :currency

    SiteVersion.update_all(exchange_rate: 1)
    SiteVersion.update_all(exchange_rate_timestamp: 1.year.ago)
  end

  def down
    remove_column :site_versions, :exchange_rate_timestamp
    remove_column :site_versions, :exchange_rate
  end
end
