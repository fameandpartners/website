on_app_master do
  sudo "monit restart sidekiq_<app_name>_0"
end