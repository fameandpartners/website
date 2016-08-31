namespace :bergen do
  # More information about this file at https://fameandpartners.atlassian.net/browse/WEBSITE-587 or https://fameandpartners.atlassian.net/browse/WEBSITE-621
  desc 'Generate GlobalSKUs from BERGEN STYLE MASTER CSV file'
  task import_global_skus: :environment do
    file_path = ENV['FILE_PATH']

    raise 'FILE_PATH required' if file_path.blank?
    raise 'File must be a CSV' if File.extname(file_path) != '.csv'

    Importers::BergenStyleMaster.new(file_path).import
  end
end
