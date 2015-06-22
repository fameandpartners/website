on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"

  run("cd #{config.release_path} && bundle exec newrelic deployment --license-key=#{node[:newrelic_key]} --appname='#{app}' ")

end
