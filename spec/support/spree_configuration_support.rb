module SpreeConfigurationSupport
  def define_spree_config_preference(key, value, type)
    Spree::AppConfiguration.class_eval do
      preference key, type
    end

    Spree.config do |config|
      config.send("#{key}=", value)
    end
  end
end

RSpec.configure do |config|
  config.include SpreeConfigurationSupport, spree_config_support: true
end
