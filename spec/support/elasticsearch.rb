RSpec.configure do |config|
  config.before(:suite) do
    Tire::Configuration.client.delete(Tire::Configuration.url)
  end
end
