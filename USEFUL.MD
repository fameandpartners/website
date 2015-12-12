sql = "UPDATE spree_products SET available_on = '2020-01-01', hidden = true
WHERE id IN
(SELECT v.product_id FROM spree_variants v
WHERE UPPER(v.sku) IN ('4B012SL', '4B14SL'))"
 ActiveRecord::Base.connection.execute(sql)

sql = "UPDATE spree_products SET available_on = '2015-01-01', hidden = false
WHERE id IN
(SELECT v.product_id FROM spree_variants v
WHERE UPPER(v.sku) IN ('4B012SL', '4B14SL))"
 ActiveRecord::Base.connection.execute(sql)

Revolution::Page.select(:id).where(:path => '/lookbook/make-a-statement').first.update_attribute(:variables, {:image_count => 8, :lookbook => true, :limit =>99 })


sql = "UPDATE spree_products_taxons SET taxon_id = 269 WHERE taxon_id = 270;"
ActiveRecord::Base.connection.execute(sql)



sql = "UPDATE product_making_options SET price = 0 WHERE option_type ='fast_making';"
ActiveRecord::Base.connection.execute(sql)
