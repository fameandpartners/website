on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"

  run("cd #{config.release_path} && bundle exec newrelic deployment --license-key=#{config.node[:newrelic_key]} --appname='#{config.app}' ")
end
