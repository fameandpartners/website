donation_settings = Spree::DonationConfiguration.new 
id_lookup = donation_settings[:id_lookup]

Deface::Override.new(:virtual_path  => "spree/orders/show",
                     :insert_before => id_lookup,
                     :text          => "<%= raw @order.payload %>",
                     :name          => "donation",
                     )

