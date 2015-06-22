on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"

  begin
    nr_config = YAML.load(File.read(File.join(config.release_path, 'config', 'newrelic.yml' )))

    if nr_config
      newrelic_api_key = nr_config['common']['license_key']
      app_name         = nr_config['common']['app_name']
      user             = config.deployed_by
      revision         = config.active_revision
      run("cd #{config.release_path} && bundle exec newrelic deployment --license-key=#{newrelic_api_key} --appname='#{app_name}' --user=#{user}  --revision=#{revision} ")
    end
  rescue StandardError => e
    puts e.message
  end

end
