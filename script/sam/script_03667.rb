
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

# Similar issue/fix for Westside dress
# Orphan some rows
raise unless LayerCad.where(product_id: 1118).pluck(:id).sort.to_s == "[4619, 4620, 4621, 4622, 4623, 4624]"
LayerCad.find(4619).update_column(:product_id, nil)
LayerCad.find(4620).update_column(:product_id, nil)
LayerCad.find(4621).update_column(:product_id, nil)
LayerCad.find(4622).update_column(:product_id, nil)
LayerCad.find(4623).update_column(:product_id, nil)
LayerCad.find(4624).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3504).update_column(:product_id, 1118)
LayerCad.find(3505).update_column(:product_id, 1118)
LayerCad.find(3506).update_column(:product_id, 1118)
LayerCad.find(3507).update_column(:product_id, 1118)
LayerCad.find(3508).update_column(:product_id, 1118)
LayerCad.find(3509).update_column(:product_id, 1118)

# Similar issue/fix for Andromeda
# Orphan some rows
raise unless LayerCad.where(product_id: 1342).pluck(:id).sort.to_s == "[4679, 4680, 4681, 4682, 4683, 4684]"
LayerCad.find(4679).update_column(:product_id, nil)
LayerCad.find(4680).update_column(:product_id, nil)
LayerCad.find(4681).update_column(:product_id, nil)
LayerCad.find(4682).update_column(:product_id, nil)
LayerCad.find(4683).update_column(:product_id, nil)
LayerCad.find(4684).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3564).update_column(:product_id, 1342)
LayerCad.find(3565).update_column(:product_id, 1342)
LayerCad.find(3566).update_column(:product_id, 1342)
LayerCad.find(3567).update_column(:product_id, 1342)
LayerCad.find(3568).update_column(:product_id, 1342)
LayerCad.find(3569).update_column(:product_id, 1342)

# Similar issue/fix for Zenith
# Orphan some rows
raise unless LayerCad.where(product_id: 1338).pluck(:id).sort.to_s == "[4596, 4597, 4598, 4599, 4600]"
LayerCad.find(4596).update_column(:product_id, nil)
LayerCad.find(4597).update_column(:product_id, nil)
LayerCad.find(4598).update_column(:product_id, nil)
LayerCad.find(4599).update_column(:product_id, nil)
LayerCad.find(4600).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3481).update_column(:product_id, 1338)
LayerCad.find(3482).update_column(:product_id, 1338)
LayerCad.find(3483).update_column(:product_id, 1338)
LayerCad.find(3484).update_column(:product_id, 1338)
LayerCad.find(3485).update_column(:product_id, 1338)

# Similar issue/fix for Midheaven
# Orphan some rows
raise unless LayerCad.where(product_id: 1363).pluck(:id).sort.to_s == "[4565, 4566, 4567, 4568, 4569, 4570]"
LayerCad.find(4565).update_column(:product_id, nil)
LayerCad.find(4566).update_column(:product_id, nil)
LayerCad.find(4567).update_column(:product_id, nil)
LayerCad.find(4568).update_column(:product_id, nil)
LayerCad.find(4569).update_column(:product_id, nil)
LayerCad.find(4570).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3451).update_column(:product_id, 1363)
LayerCad.find(3452).update_column(:product_id, 1363)
LayerCad.find(3453).update_column(:product_id, 1363)
LayerCad.find(3454).update_column(:product_id, 1363)
LayerCad.find(3455).update_column(:product_id, 1363)
LayerCad.find(3456).update_column(:product_id, 1363)
