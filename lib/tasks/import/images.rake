require 'pathname'
require 'batch_upload/images_uploader'

namespace :import do
  namespace :product do
    desc 'Import images for products (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::ProductImagesUploader.new(location)
      uploader.process!
    end
  end

  namespace :customization do
    desc 'Import images for customizations (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::CustomizationImagesUploader.new(location)
      uploader.process!
    end
  end

  namespace :accessory do
    desc 'Import images for accessories (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::AccessoryImagesUploader.new(location)
      uploader.process!
    end
  end

  namespace :moodboard do
    desc 'Import images for moodboards (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::MoodboardImagesUploader.new(location)
      uploader.process!
    end
  end

  namespace :perfume do
    desc 'Import images for perfume (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::PerfumeImagesUploader.new(location)
      uploader.process!
    end
  end

  namespace :song do
    desc 'Import images for songs (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::SongImagesUploader.new(location)
      uploader.process!
    end
  end
end

def validate_location!
  unless ENV['LOCATION'].present?
    raise 'No LOCATION value given. Please set LOCATION as path to directory!'
  end

  unless Dir.exists?(ENV['LOCATION'])
    raise 'Invalid LOCATION value given. Please set LOCATION as path to directory!'
  end
end

def location
  Pathname(ENV['LOCATION']).realpath
end


