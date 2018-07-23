require 'pathname'
require 'batch_upload/images_uploader'

namespace :import do
  namespace :product do
    desc 'Import images for products (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!
      file_path = ENV['FILE_PATH']
      available = ENV['AVAILABLE'] || 1.days.ago
      mark_new_this_week = DataCoercion.string_to_boolean(ENV['MARK_NEW_THIS_WEEK'])

      STDOUT.sync = true
      puts "#{DateTime.now} START XLS IMPORTER"
      # We need an XLS file now to get all of the fabric/color data out of 
      batch_uploader  = Products::BatchUploader.new(available, mark_new_this_week)
      batch_uploader.parse_file(file_path)
      
      uploader = BatchUpload::ProductImagesUploader.new(location, :delete)
      puts batch_uploader.parsed_data.first
      uploader.process!( batch_uploader.parsed_data.first[:color_data] )
      
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

      uploader = BatchUpload::InspirationImagesUploader.new(location)
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

  namespace :cads do
    desc 'Import images for songs (specify directory location w/ LOCATION=/path/to/directory)'
    task :images => :environment do
      validate_location!

      uploader = BatchUpload::CadsImagesUploader.new(location)
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


