Spree::Product.class_eval do
  serialize :tags, Array

  after_save {|product| StyleQuiz::ProductStyleProfileIndex.new(product).update }
end
