%w(spree).each do |folder| 
  run "echo 'release_path: #{release_path}/public/#{folder}' >> #{shared_path}/#{folder}"
  run "ln -nfs #{shared_path}/#{folder} #{release_path}/public/#{folder}" 
end 
