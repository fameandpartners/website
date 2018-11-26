# encoding: utf-8

namespace :import do
  desc 'Import product data from Excel file'
  task :data => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    raise 'MARK_NEW_THIS_WEEK required (true/false) . True will set new this week taxons for new products . False will not .' if ENV['MARK_NEW_THIS_WEEK'].blank? || !(ENV['MARK_NEW_THIS_WEEK'].downcase.in?(["true","false","yes","no"]))

    file_path = ENV['FILE_PATH']
    available = ENV['AVAILABLE'] || 1.days.ago
    mark_new_this_week = DataCoercion.string_to_boolean(ENV['MARK_NEW_THIS_WEEK'])

    STDOUT.sync = true
    puts "#{DateTime.now} START XLS IMPORTER"


    uploader = Products::BatchUploader.new(available, mark_new_this_week)
    uploader.parse_file(file_path)

    @parsed_data = uploader.parsed_data

    uploader.create_or_update_products(@parsed_data)

    Rake::Task['update:images:positions'].execute
  end
end
