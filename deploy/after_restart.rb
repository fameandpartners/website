on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"
end