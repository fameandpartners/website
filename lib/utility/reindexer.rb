# usage:
# Utility::Reindexer.reindex
module Utility
  class Reindexer

    def self.reindex
      Products::ColorVariantsIndexer.index!
    end
  end
end
