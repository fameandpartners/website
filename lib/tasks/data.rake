# encoding: utf-8

namespace :import do
  desc 'Import product data from Excel file'
  task :data => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']
    puts "#{DateTime.now} START XLS IMPORTER"

    uploader = Products::BatchUploader.new()
    uploader.parse_file(file_path)

    @parsed_data = uploader.parsed_data

    uploader.create_or_update_products(@parsed_data)

    Rake::Task['update:images:positions'].execute
  end
end
