begin
  # http://stackoverflow.com/questions/12499404/can-i-run-a-rails-engines-specs-from-a-real-app-which-mounts-it
  require "rspec/core/rake_task"


  RSpec::Core::RakeTask.new(:spec)

  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    # Turn off full list of files being run.
    t.verbose = false
  end

  task :default => :spec
  RSpec::Core::RakeTask.module_eval do
    def pattern
      extras = []
      Rails.application.config.rspec_paths.each do |dir|
        if File.directory?(dir)
          extras << File.join(dir, 'spec', '**', '*_spec.rb').to_s
        end
      end
      [@pattern] | extras
    end
  end

rescue LoadError
  # Running in a non dev/test environment
end
