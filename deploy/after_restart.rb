on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"

  begin
    run("cd #{config.release_path} && bundle exec newrelic deployment --license-key=#{config.node[:newrelic_key]} --appname='#{config.app}' ")

  rescue StandardError => e
    puts e.message
  end

end
