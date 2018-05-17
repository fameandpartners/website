
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

# Similar issue/fix for Allegra
# Orphan some rows
raise unless LayerCad.where(product_id: 680).pluck(:id).sort.to_s == "[4769, 4770, 4771, 4772, 4773, 4774]"
LayerCad.find(4769).update_column(:product_id, nil)
LayerCad.find(4770).update_column(:product_id, nil)
LayerCad.find(4771).update_column(:product_id, nil)
LayerCad.find(4772).update_column(:product_id, nil)
LayerCad.find(4773).update_column(:product_id, nil)
LayerCad.find(4774).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3654).update_column(:product_id, 680)
LayerCad.find(3655).update_column(:product_id, 680)
LayerCad.find(3656).update_column(:product_id, 680)
LayerCad.find(3657).update_column(:product_id, 680)
LayerCad.find(3658).update_column(:product_id, 680)
LayerCad.find(3659).update_column(:product_id, 680)

# Similar issue/fix for Surreal Dreamer
# Orphan some rows
raise unless LayerCad.where(product_id: 1292).pluck(:id).sort.to_s == "[4811, 4812, 4813, 4814, 4815, 4816]"
LayerCad.find(4811).update_column(:product_id, nil)
LayerCad.find(4812).update_column(:product_id, nil)
LayerCad.find(4813).update_column(:product_id, nil)
LayerCad.find(4814).update_column(:product_id, nil)
LayerCad.find(4815).update_column(:product_id, nil)
LayerCad.find(4816).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3696).update_column(:product_id, 1292)
LayerCad.find(3697).update_column(:product_id, 1292)
LayerCad.find(3698).update_column(:product_id, 1292)
LayerCad.find(3699).update_column(:product_id, 1292)
LayerCad.find(3700).update_column(:product_id, 1292)
LayerCad.find(3701).update_column(:product_id, 1292)

# Similar issue/fix for Antares
# Orphan some rows
raise unless LayerCad.where(product_id: 1339).pluck(:id).sort.to_s == "[4559, 4560, 4561, 4562, 4563, 4564]"
LayerCad.find(4559).update_column(:product_id, nil)
LayerCad.find(4560).update_column(:product_id, nil)
LayerCad.find(4561).update_column(:product_id, nil)
LayerCad.find(4562).update_column(:product_id, nil)
LayerCad.find(4563).update_column(:product_id, nil)
LayerCad.find(4564).update_column(:product_id, nil)
# Correct mappings
LayerCad.find(3445).update_column(:product_id, 1339)
LayerCad.find(3446).update_column(:product_id, 1339)
LayerCad.find(3447).update_column(:product_id, 1339)
LayerCad.find(3448).update_column(:product_id, 1339)
LayerCad.find(3449).update_column(:product_id, 1339)
LayerCad.find(3450).update_column(:product_id, 1339)

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
