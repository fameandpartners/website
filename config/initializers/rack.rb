if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('4')
  Rack::Utils.multipart_part_limit = 400
else
  puts '------------------------------------------------------------------------------------------------------'
  puts 'Rails is on its 4 version! Upgrade Rack to its latest version to solve rack/rack#814, "Too many open files"'
  puts '------------------------------------------------------------------------------------------------------'
end
