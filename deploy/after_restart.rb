on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"
  is_production = config.framework_env == 'production'

  # Alert deployment to NewRelic
  begin
    nr_config = YAML.load(File.read(File.join(config.release_path, 'config', 'newrelic.yml')))

    if nr_config && is_production
      newrelic_api_key = nr_config['common']['license_key']
      app_name         = nr_config['common']['app_name']
      user             = config.deployed_by
      revision         = config.active_revision
      run("cd #{config.release_path} && bundle exec newrelic deployment --license-key=#{newrelic_api_key} --appname='#{app_name}' --user=#{user}  --revision=#{revision} ")
    end
  rescue StandardError => e
    puts e.message
  end

  # # Alert Bugsnag about deploy
  # begin
  #   revision        = config.active_revision
  #   release_stage   = config.framework_env
  #   # TODO - Duplicated with config/initializers/bugsnag.rb
  #   bugsnag_api_key = "997499c3e18822c6412e414ca82a86e4"
  #
  #   run("cd #{config.release_path} && curl -d \"apiKey=#{bugsnag_api_key}&revision=#{revision}&releaseStage=#{release_stage}\" http://notify.bugsnag.com/deploy" )
  #
  # rescue StandardError => e
  #   puts e.message
  # end

  # Run Clear Cache worker
  begin
    run("cd #{config.release_path} && bundle exec rake cache:expire &")
  rescue StandardError => e
    puts e.message
  end
end
