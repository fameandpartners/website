namespace :pin do

  desc 'import refunds'
  task :refunds => :environment do

    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    importer = PinRefunds::Importer.new(ENV['FILE_PATH'])
    importer.import
  end

  desc 'get_test_transactions'
  task :get_test_transactions => :environment do

    test_secret_key = 'LElcjB_z4BItXJQPYlw43g'
    test_public_key = 'pk_iaPOLVAQMh7nTJ0WhECpUA'
    test_api_url    = 'https://test-api.pin.net.au'

    PinPayment.api_url = test_api_url

    PinPayment.public_key = test_public_key
    PinPayment.secret_key = test_secret_key

    PinPayment::Charge.all.map { |charge|
      request = RefundRequest.new.set_from_charge(charge)
      request.public_key = test_public_key
      request.secret_key = test_secret_key
      request.api_url    = test_api_url
      request.save
    }
  end
end
