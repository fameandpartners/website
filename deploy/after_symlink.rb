%w(spree).each do |folder| 
  run "echo 'release_path: #{config.release_path}/public/#{folder}' >> #{config.shared_path}/#{folder}"
  run "ln -nfs #{config.shared_path}/#{folder} #{config.release_path}/public/#{folder}"
end

run "cd #{release_path} && bundle exec whenever --update-crontab '#{app}_#{node[:environment][:framework_env]}'"
