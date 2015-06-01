namespace :import do
  desc 'shipping tracking numbers - but without emailing the client.'
  task :shipment_without_emails => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    file_path = ENV['FILE_PATH']

    Importers::ShipmentTracking.new(file_path).import
  end
end
