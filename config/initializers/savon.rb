if Rails.env.development?
  Savon.configure do |config|
    config.log              = true
    config.log_level        = :debug
    config.pretty_print_xml = true
  end
end

if ENV.fetch('SAVON_ENABLE_LOGS', false)
  savon_log_level = ENV.fetch('SAVON_LOG_LEVEL', 'debug').to_s.to_sym

  Savon.configure do |config|
    config.log              = true
    config.log_level        = savon_log_level
    config.pretty_print_xml = true
  end
end
