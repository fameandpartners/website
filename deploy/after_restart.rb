on_app_master do
  sudo "monit restart sidekiq_#{config.app}_0"
  puts "i hate contractors"
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

  # Alert Sentry about deploy
  begin
    revision = config.active_revision
    command  = <<-COMMAND
      curl https://app.getsentry.com/api/hooks/release/builtin/68181/27cffdebddcf062bf0b2a5a0ac18c48deb45581dbcb44aa1d2ac73921b0b9a58/ \
      -X POST \
      -H 'Content-Type: application/json' \
      -d '{"version": "#{revision}"}'
    COMMAND

    run(command)
  rescue StandardError => e
    puts e.message
  end

  # Run Clear Cache worker
  begin
    run("cd #{config.release_path} && bundle exec rake cache:expire &")
  rescue StandardError => e
    puts e.message
  end
end
