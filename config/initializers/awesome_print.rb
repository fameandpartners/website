if Rails.env.development? && ENV['AWESOME_PRINT_DISABLE'] != 'true'
  AwesomePrint.irb!
  AwesomePrint.pry!
end
