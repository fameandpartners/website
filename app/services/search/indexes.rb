module Search
  class Indexes
    def self.build
      Products::ColorVariantsIndexer.index!
    end
  end
end
