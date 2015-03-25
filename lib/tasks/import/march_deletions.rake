namespace :import do
  desc 'delete known gone products'
  task :march_2015_deletions => :environment do

    deleteables = %w{
      4B002DL
      4B005SS
      4B006SS
      4B007DL
      4B008SS
      4B013
      4B020DL
      4B021SS
      4B024SL
      4B026SS
      4B027SS
      4B028SL
      4B030SS
      4B036
      4B037
      4B039
      4B041SL
      4B045
      4B046
      4B047SS
      4B049
      4B050
      4B055
      4B056
      4B059
      4B060
      4B065
      4B072
      4B073E
      4B095
      4B103
      4B111
      4B112
      4B114
      4B117
      4B126
      4B127
      4B131
      4B134
      4B135
      4B142
      4B143
      4B144
      4B163
      4B170
      4B191
      4B198
      4B199
      1310001DL
      1310002DL
      1310003
      1310007DL
      1310010CS
      1310012DL
      1310013DL
      1310014
      1310019CL
      1310026DL
      1310028DL
      1310030SL
      1310031CS
      1310033SS
      1310035SL
      1310038SS
      1310040SS
      1310041SS
      1310042SS
      1310043SS
      1310045SS
      1310046SS
      1310047SS
      1310048SS
      1310049SS
      FPSS13001
      FPSS13003
      FPSS13004
      FPSS13006
      FPSS13010
      FPSS13012
      FPSS13017
      FPSS13024
      FPSS13029
      FPSS13033
      FPSS13037
      FPSS13063
      }

    deleteables.each do |sku|
      variant = Spree::Variant.where(is_master: true, sku: sku.downcase).order('id DESC').first
      if variant
        puts "deleting product sku:#{sku} id:#{variant.product.id} name:#{variant.product.name}"
      end
      variant.product.delete if variant
    end
  end
end
