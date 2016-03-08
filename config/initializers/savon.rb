if Rails.env.development?
  Savon.configure do |config|
    config.log       = true
    config.log_level = :debug
  end
end
