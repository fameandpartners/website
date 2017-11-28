namespace :data do
  task :add_fabric_samples => :environment do
    catty = Category.new
    catty.category = 'Sample'
    catty.subcategory = 'Fabric'
    catty.save

    samples = [
      ['ivory', 'fp-sp0065', 65],
      ['pale-grey', 'fp-sp0179', 179],
      ['black', 'fp-sp0025', 25],
      ['champagne', 'fp-sp0082', 82],
      ['pale-pink', 'fp-sp0057', 57],
      ['blush', 'fp-sp0090', 90],
      ['peach', 'fp-sp0039', 39],
      ['guava', 'fp-sp0484', 484],
      ['red', 'fp-sp0026', 26],
      ['burgundy', 'fp-sp0089', 89],
      ['berry', 'fp-sp0164', 164],
      ['lilac' 'fp-sp0061', 61],
      ['navy', 'fp-sp0070', 70],
      ['royal-blue', 'fp-sp0067', 67],
      ['pale-blue', 'fp-sp0079', 79],
      ['mint', 'fp-sp0055', 55],
      ['bright-turquoise', 'fp-sp0390', 390],
      ['sage-green', 'fp-sp0228', 228]
    ]


  end

end
