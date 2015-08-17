module Preferences
  class Base
    def preference_value(key)
      Spree::Config[key] if Spree::Config.has_preference?(key)
    end
  end
end
