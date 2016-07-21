namespace :mailchimp do
  desc "Create store if not created yet"
  task :create_store_if_not_created_yet => :environment do
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    store_id = 'fame_and_partners'

    store_params = {
      id: store_id,
      list_id: ENV['MAILCHIMP_LIST_ID'],
      name: 'Fame and Partners',
      currency_code: 'USD'
    }

    unless store_exists?(gibbon, store_id)
      gibbon.ecommerce.stores.create(body: store_params)
    end
  end

  def store_exists?(gibbon, store_id)
    gibbon.ecommerce.stores(store_id).retrieve
    true
  rescue Gibbon::MailChimpError => e
    false
  end
end
