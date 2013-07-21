namespace "db" do
  namespace "populate" do
    desc "create default taxonomy"
    task :countries => :environment do
      add_countries
      add_states
    end
  end
end

def add_countries
  puts 'TODO: add_countries'
end

def add_states
  puts 'TODO: add_states'
end
