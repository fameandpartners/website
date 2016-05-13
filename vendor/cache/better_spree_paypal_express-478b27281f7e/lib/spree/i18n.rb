# core/lib/spree/i18n.rb from spree 2.0
require 'i18n'

module Spree
  class << self
    # Add spree namespace and delegate to Rails TranslationHelper for some nice
    # extra functionality. e.g return reasonable strings for missing translations
    def translate(*args)
      I18n.t(*args)
    end

    alias_method :t, :translate
  end
end
