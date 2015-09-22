# encoding: utf-8

namespace :import do
  desc 'Import product data from Excel file'
  task :data => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']
    available = ENV['AVAILABLE'] || 1.days.ago
    STDOUT.sync = true
    puts "#{DateTime.now} START XLS IMPORTER"


    uploader = Products::BatchUploader.new(available)
    uploader.parse_file(file_path)

    @parsed_data = uploader.parsed_data

    uploader.create_or_update_products(@parsed_data)

    Rake::Task['update:images:positions'].execute
  end

  task :data_Tania_version => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']
    available = ENV['AVAILABLE'] || 1.days.ago
    puts "#{DateTime.now} START XLS IMPORTER"


    uploader = Products::BatchUploaderTaniaVersion.new(available)
    uploader.parse_file(file_path)

    @parsed_data = uploader.parsed_data

    uploader.create_or_update_products(@parsed_data)

    Rake::Task['update:images:positions'].execute
  end
end
