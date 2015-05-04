namespace :import do
  desc 'sku_generation_template'
  task :sku_generation_template => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']

    Importers::SkuGeneration.new(file_path).import
  end
end
