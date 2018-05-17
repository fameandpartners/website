
# The Olsen Dress
# The cads are in s3 in folders named
#   3524..3539
# So alter layer_cads table to point to those folders,
#
# Orphan some rows
raise unless LayerCad.where(product_id: 1106).pluck(:id).to_s == '[4649, 4650, 4651, 4652, 4654, 4653]'
LayerCad.find(4649).update_column(:product_id, nil)
LayerCad.find(4650).update_column(:product_id, nil)
LayerCad.find(4651).update_column(:product_id, nil)
LayerCad.find(4652).update_column(:product_id, nil)
LayerCad.find(4653).update_column(:product_id, nil)
LayerCad.find(4654).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3534).update_column(:product_id, 1106)
LayerCad.find(3535).update_column(:product_id, 1106)
LayerCad.find(3536).update_column(:product_id, 1106)
LayerCad.find(3537).update_column(:product_id, 1106)
LayerCad.find(3538).update_column(:product_id, 1106)
LayerCad.find(3539).update_column(:product_id, 1106)
