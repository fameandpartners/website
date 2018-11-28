# usage:
# Utility::Reindexer.reindex
module Utility
  class Reindexer

    def self.reindex
      Products::ColorVariantsIndexer.index!
      Rails.cache.clear
    end
  end
end
