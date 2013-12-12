%w(spree).each do |folder| 
  run "echo 'release_path: #{config.release_path}/public/#{folder}' >> #{config.shared_path}/#{folder}"
  run "ln -nfs #{config.shared_path}/#{folder} #{config.release_path}/public/#{folder}"
end

on_app_master do
  run "cd #{config.release_path} && bundle exec whenever --update-crontab '#{config.app}_#{config.node[:environment][:framework_env]}'"
end
