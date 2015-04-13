namespace :import do
  desc 'factories for products'
  task :factories => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']

    Products::FactoryImporter.new(file_path).import
  end
end
