class AddExchangeRateToSiteVersion < ActiveRecord::Migration
  def up
    add_column :site_versions, :exchange_rate_timestamp, :date, after: :currency
    add_column :site_versions, :exchange_rate, :decimal, default: 1, after: :currency
  end

  def down
    remove_column :site_versions, :exchange_rate_timestamp
    remove_column :site_versions, :exchange_rate
  end
end
